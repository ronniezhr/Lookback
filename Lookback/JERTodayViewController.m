//
//  JERTodayViewController.m
//  Lookback
//
//  Created by Emily Scharff on 7/14/14.
//

#import "JERTodayViewController.h"

#import "JERAddEventViewController.h"
#import "JERCollectionViewCell.h"
#import "JERDay.h"
#import "JEREmojiImage.h"
#import "JEREvent.h"
#import "Parse/Parse.h"
#import "UIColor+JERColors.h"
#import "UIFont+JERFonts.h"
#import "JERBackButtonView.h"

@interface JERTodayViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSDate *_date;
    PFUser *_user;
    UILabel *_dateLabel;
    UILabel *_feelingLabel;
    
    JEREvent *_fakeEvent; // fake "New Event" button
    
    UICollectionView *_todayEvents;
    
    UIView * _expandingCell;
    CGRect _expandingCellFrame;
    
    JERBackButtonView *_backButton;
    UIButton *_specialButton;
    
    UIScrollView *_scrollView;
    BOOL _fadeAnimation;
    
    BOOL _readOnly;

    NSIndexPath *_deletionIndexPath;
}

@property (atomic, assign) CGSize cellSize;

@end

@implementation JERTodayViewController

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    // Fake "New Event" button
    _fakeEvent = [[JEREvent alloc] init];
    _fakeEvent.title = @"+ add new";
    
    //InitializingFeelingLabel
    _feelingLabel = [[UILabel alloc] init];
    _feelingLabel.textColor = [UIColor backgroundColor];
    _feelingLabel.font = [UIFont lookbackHeaderFont];
    _feelingLabel.text = @"how was your day?";
    
    emoji_choice = @[@"\U0001F62D", @"\U0001F612", @"\U0001F610", @"\U0001F60A", @"\U0001F60D"];
    
    _fadeAnimation = YES;
    
    return self;
}

- (instancetype)initWithReadOnly
{
    self = [self init];
    _readOnly = YES;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor todayColor];
    
    //Initialize Date Stuff
    NSDate *tempDate;
    if (self.today) {
        tempDate = self.today.date;
    } else {
        tempDate = [NSDate date];
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar]components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor backgroundColor];
    
    _user = [PFUser currentUser];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    NSString *dateText = [dateFormatter stringFromDate:_date];
    _dateLabel.text = dateText;
    _dateLabel.font = [UIFont lookbackRegularFont];
    
    //Setting up dateLabel
    CGSize dateLabelSize = [_dateLabel sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat dateLabelX = roundf(self.view.bounds.size.width-dateLabelSize.width-self.view.bounds.size.width/20.0f);
    CGFloat dateLabelY = roundf(dateLabelSize.height);
    CGRect dateLabelFrame = CGRectMake(dateLabelX, dateLabelY, dateLabelSize.width, dateLabelSize.height);
    _dateLabel.frame = dateLabelFrame;
    
    [self.view addSubview:_dateLabel];
    
    if (!self.today) {
        // Find Today's Day
        PFQuery *todayQuery = [JERDay query];
        [todayQuery whereKey:@"date" equalTo:_date];
        [todayQuery whereKey:@"user" equalTo:_user];
        
        NSArray *days = [todayQuery findObjects]; // TODO use background completion
        if (days.count) {
            NSAssert(days.count == 1, @"shouldn't have multiple day objects per date!");
            self.today = days[0];
            PFQuery *todaysEventsQuery = [JEREvent query];
            [todaysEventsQuery whereKey:@"date" equalTo:_date];
            [todaysEventsQuery whereKey:@"user" equalTo:_user];
            [self.today addEvent:_fakeEvent];
            [self.today addEventsFromArray:[todaysEventsQuery findObjects]];
        } else {
            // create a day for today
            self.today = [[JERDay alloc] init];
            self.today.mood = 3;
            self.today.date = _date;
            self.today.user = _user;
            [self.today addEvent:_fakeEvent];
            [self.today saveInBackground];
        }
    }
    
    // Setting Up feelingLabel
    CGSize feelingLabelSize = [_feelingLabel sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat feelingLabelX = roundf((self.view.bounds.size.width-dateLabelSize.width) / 3.5f);
    CGFloat feelingLabelY = roundf((self.view.bounds.size.height-dateLabelSize.height) / 9.0f);
    CGRect feelingLabelFrame = CGRectMake(feelingLabelX, feelingLabelY, feelingLabelSize.width, feelingLabelSize.height);
    _feelingLabel.frame = feelingLabelFrame;
    [_feelingLabel sizeToFit];
    [self.view addSubview:_feelingLabel];
    
    // Setting up Back Button
    _backButton = [[JERBackButtonView alloc] init];
    CGSize backButtonSize = [_backButton sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    _backButton.frame = CGRectMake(15, 25, backButtonSize.width, backButtonSize.height);
    _backButton.color = [UIColor backgroundColor];
    [_backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    // Day's Events
    CGRect eventsFrame = CGRectMake(0, self.view.bounds.size.height * 4.5 / 12.0f, self.view.bounds.size.width, self.view.bounds.size.height * 2 / 3.0f);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    NSUInteger cellsNum = [self.today.events count];
    NSUInteger numPerRow = 3;

    float factor = 1.0f;
    if (cellsNum < 2) {
        factor = 3.0f;
        numPerRow = 1;
    } else if (cellsNum < 5) {
        factor = 1.5f;
        numPerRow = 2;
    }
    
    CGFloat defaultWidth = factor * self.view.bounds.size.width / 3.3f;
    self.cellSize = CGSizeMake(defaultWidth, defaultWidth);
    layout.itemSize = self.cellSize;
    
    CGFloat remainingSpace = (self.view.bounds.size.width - (defaultWidth * numPerRow)) / (numPerRow + 2);
    layout.sectionInset = UIEdgeInsetsMake(remainingSpace + 10.0f, remainingSpace, remainingSpace, remainingSpace);
    layout.minimumInteritemSpacing = remainingSpace;
    layout.minimumLineSpacing = remainingSpace;
    
    _todayEvents = [[UICollectionView alloc] initWithFrame: eventsFrame collectionViewLayout:layout];
    [_todayEvents setDataSource:self];
    [_todayEvents setDelegate:self];
    
    [_todayEvents registerClass:[JERCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _todayEvents.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_todayEvents];
    
    CGFloat scrollY = roundf( self.view.bounds.size.height / 6.0f );
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollY, self.view.frame.size.width, self.view.frame.size.height / 4)];
    [_scrollView setAlwaysBounceHorizontal:YES];
    int numberOfViews = 5;
    for (int i = 0; i < numberOfViews + 2; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width / 3;
        UIImageView *image = [[UIImageView alloc] initWithFrame: CGRectMake(xOrigin, 0, self.view.frame.size.width / 3.0, self.view.frame.size.height / 4.0)];
        if ((i > 0) && (i <= numberOfViews)) {
            image.image = [JEREmojiImage imageWithEmoji:emoji_choice[i - 1] withSize:self.view.frame.size.height / 4.5];
            image.contentMode = UIViewContentModeScaleAspectFit;
        }
        [_scrollView addSubview:image];
    }

    [_scrollView setDelegate:self];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width / 3 * (numberOfViews + 2), self.view.frame.size.height / 4)];
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width / 3 * (self.today.mood - 1), 0)];
    
    if (_readOnly) {
        _scrollView.scrollEnabled = NO;
    } else {
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        singleTapGestureRecognizer.enabled = YES;
        singleTapGestureRecognizer.cancelsTouchesInView = NO;
        [_scrollView addGestureRecognizer:singleTapGestureRecognizer];
    }
    
    [self.view addSubview:_scrollView];
    
    // draw box
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, scrollY + 15, self.view.frame.size.width / 3, self.view.frame.size.width / 3)];
    box.backgroundColor = [UIColor boxBackgroundColor];
    box.layer.borderColor = [UIColor boxBorderColor].CGColor;
    box.layer.borderWidth = 1.5f;
    [self.view addSubview:box];
    [self.view sendSubviewToBack:box];
    
    if (_fadeAnimation) {
        _backButton.alpha = 0;
        _dateLabel.alpha = 0;
        _feelingLabel.alpha = 0;
        _scrollView.alpha = 0;
        _todayEvents.alpha = 0;
        box.alpha = 0;
        
        [UIView animateWithDuration:2.0f animations: ^{
            _backButton.alpha = 1;
            _dateLabel.alpha = 1;
            _feelingLabel.alpha = 1;
            _scrollView.alpha = 1;
            _todayEvents.alpha = 1;
            box.alpha = 1;
        } ];
    }
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress: )];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    longPressGestureRecognizer.delegate = self;
    [_todayEvents addGestureRecognizer:longPressGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.presentedViewController) {
        JEREvent *lastEvent = self.today.events.lastObject;
        if ((!lastEvent.image) && (!lastEvent.text)) {
            [self.today removeEvent:lastEvent];
        }
        [_scrollView removeFromSuperview];
        [_todayEvents removeFromSuperview];
        [self viewDidLoad];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat step = self.view.frame.size.width / 3;
    int scrollIndex = round(targetContentOffset->x / step);
    self.today.mood = scrollIndex + 1;
    targetContentOffset->x = scrollIndex * step;
}

- (void)scrollViewTap:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:_scrollView];
    CGFloat step = self.view.frame.size.width / 3;
    int scrollIndex = (int) (touchPoint.x / step);
    if ((scrollIndex > 0) && (scrollIndex <= 5)) {
        [_scrollView setContentOffset:CGPointMake((scrollIndex - 1) * step, 0) animated:YES];
        self.today.mood = scrollIndex;
    }
}

- (void)longPress: (UIGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }

    CGPoint p = [sender locationInView:_todayEvents];
    _deletionIndexPath = [_todayEvents indexPathForItemAtPoint:p];
    
    if (_deletionIndexPath) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Event?" message:@"\U0001F62D" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"Cancel", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *actionTitle = [alertView buttonTitleAtIndex:buttonIndex];

    if ([actionTitle isEqualToString:@"Yes"]) {
        NSInteger index = _deletionIndexPath.item;
        JEREvent *deleteEvent = [self.today.events objectAtIndex:index];
        [deleteEvent deleteInBackground];
        [self.today removeEvent:deleteEvent];
        [self.today saveInBackground];
        [_todayEvents deleteItemsAtIndexPaths:[NSArray arrayWithObject:_deletionIndexPath]];

        [alertView removeFromSuperview];
        [_todayEvents removeFromSuperview];
        [_scrollView removeFromSuperview];
        [self viewDidLoad];
    }
}

- (void)backButtonTapped:(id)sender
{
    [self.today removeEvent:_fakeEvent];
    [self.today saveInBackground];
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.today.events count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JERCollectionViewCell *cell =[_todayEvents dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    JEREvent *event = [self.today.events objectAtIndex:indexPath.item];
    cell.image = event.image;
    cell.cellSize = self.cellSize;
    cell.description = event.title;
    cell.backgroundColor = [UIColor newEventColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JERAddEventViewController *newEventController;
    if (_readOnly) {
        newEventController = [[JERAddEventViewController alloc] initWithReadOnly];
    }else {
        newEventController = [[JERAddEventViewController alloc] init];
    }
    JEREvent *currEvent = [self.today.events objectAtIndex:indexPath.item];
    if (currEvent != _fakeEvent) {
        newEventController.event = currEvent;
    } else {
        JEREvent *newEvent = [[JEREvent alloc] init];
        newEventController.event = newEvent;
        [self.today addEvent:newEvent];
    }
    
    JERCollectionViewCell *cell = [_todayEvents cellForItemAtIndexPath:indexPath];
    _expandingCellFrame = CGRectMake(cell.frame.origin.x + _todayEvents.frame.origin.x, cell.frame.origin.y + _todayEvents.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    
    _expandingCell = [[UIView alloc] initWithFrame:_expandingCellFrame];
    _expandingCell.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_expandingCell];
    
    [UIView animateWithDuration:0.5f animations:^{
        [_expandingCell setBackgroundColor:[UIColor newEventColor]];
    } ];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view bringSubviewToFront:_expandingCell];
        _expandingCell.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        [self presentViewController:newEventController animated:NO completion:NULL];
    } ];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    _fadeAnimation = NO;
    [super dismissViewControllerAnimated:flag completion:completion];
    [self.view bringSubviewToFront:_expandingCell];
    
    [UIView animateWithDuration:0.5f animations:^{
        _expandingCell.frame = _expandingCellFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            _expandingCell.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [_expandingCell removeFromSuperview];
            _fadeAnimation = YES;
        } ];
    } ];
    
}

-(BOOL)shouldAutorotate {
    return false;
}

@end
