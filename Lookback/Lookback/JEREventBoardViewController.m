//
//  JEREventBoardViewController.m
//  Lookback
//
//  Created by Jooeun Lim on 7/14/14.
//

#import "JEREventBoardViewController.h"

#import "JERAddEventViewController.h"
#import "JERCollectionViewCell.h"
#import "JERDay.h"
#import "JEREvent.h"
#import "JERTodayViewController.h"
#import "Parse/Parse.h"
#import "UIColor+JERColors.h"
#import "UIFont+JERFonts.h"
#import "JERBackButtonview.h"


@interface JEREventBoardViewController () {
    UILabel *_actionLabel;
    JERBackButtonView *_doneButton;
    NSArray *_datesToDisplay;
    PFUser *_user;
    UIView *_expandingCell;
    CGRect _expandingCellFrame;
    BOOL _fadeAnimation;
    NSIndexPath *_deletionIndexPath;
    UIColor *_origColor;
    UICollectionViewCell *_cellToDelete;
}

@end

@implementation JEREventBoardViewController

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _actionLabel = [[UILabel alloc] init];
    [_actionLabel setText:@"past days"];
    [_actionLabel setFont:[UIFont lookbackHeaderFont]];
    [_actionLabel setTextColor:[UIColor backgroundColor]];
    
    _user = [PFUser currentUser];
    PFQuery *daysQuery = [JERDay query];
    [daysQuery whereKey:@"user" equalTo:_user];
    _datesToDisplay = [daysQuery findObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    _datesToDisplay = [_datesToDisplay sortedArrayUsingDescriptors:sortDescriptors];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lookBackColor];
    
    CGSize nameSize = [_actionLabel sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat nameX = roundf( (self.view.bounds.size.width - nameSize.width) / 2.0f );
    CGFloat nameY = 100.0f;
    CGRect nameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    _actionLabel.frame = nameFrame;
    
    _doneButton = [[JERBackButtonView alloc] init];
    _doneButton.transform = CGAffineTransformMakeRotation(M_PI / -2);
    CGSize backButtonSize = [_doneButton sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    _doneButton.frame = CGRectMake(15.0f, 35.0f, backButtonSize.width, backButtonSize.height);
    _doneButton.color = [UIColor backgroundColor];
    [_doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneButton];
    
    CGSize collectionSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - nameY - 100.0f);
    CGFloat collectionX = roundf( (self.view.bounds.size.width - collectionSize.width) / 2.0 );
    CGFloat collectionY = roundf(nameY + 60.0f);
    CGRect collectionFrame = CGRectMake(collectionX, collectionY, collectionSize.width, collectionSize.height);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame
                                         collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[JERCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor: [[UIColor backgroundColor]colorWithAlphaComponent:0.9f]];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressRecognizer.minimumPressDuration = 0.5;
    longPressRecognizer.delegate = self;
    [_collectionView addGestureRecognizer:longPressRecognizer];
    
    [self.view addSubview:_actionLabel];
    [self.view addSubview:_doneButton];
    [self.view addSubview:_collectionView];
    
    _collectionView.alpha = 0;
    _actionLabel.alpha = 0;
    _doneButton.alpha = 0;
    
    [UIView animateWithDuration:0.5f animations:^{
        _collectionView.alpha = 1;
        _actionLabel.alpha = 1;
        _doneButton.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)done: (id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (void)longPressed: (UIGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint p = [sender locationInView:_collectionView];
    _deletionIndexPath = [_collectionView indexPathForItemAtPoint:p];
    
    if (_deletionIndexPath) {
        _cellToDelete = [_collectionView cellForItemAtIndexPath:_deletionIndexPath];
        _origColor = _cellToDelete.backgroundColor;
        _cellToDelete.backgroundColor = [UIColor blackColor];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Day?" message:@"\U0001F628" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"Cancel", nil];
        
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *actionTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([actionTitle isEqualToString:@"Cancel"]) {
        [_collectionView cellForItemAtIndexPath:_deletionIndexPath].backgroundColor = _origColor;
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_deletionIndexPath.row inSection:_deletionIndexPath.section];
        NSMutableArray *temp = [_datesToDisplay mutableCopy];
        NSInteger index = indexPath.item;
        JERDay *deleteDate = [_datesToDisplay objectAtIndex:index];
        [deleteDate deleteInBackground];
        [temp removeObjectAtIndex:index];
        _datesToDisplay = [temp copy];
        [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    }
    [alertView removeFromSuperview];
    [_collectionView removeFromSuperview];
    [self viewDidLoad];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_datesToDisplay count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JERCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    JERDay *day = [_datesToDisplay objectAtIndex:indexPath.item];
    
    CGSize cellSize = CGSizeMake(100, 100);
    [cell setCellSize:cellSize];
    
    for (UILabel *label in cell.contentView.subviews) {
        [label removeFromSuperview];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM / dd / yyyy"];
    [cell setDescription:[dateFormatter stringFromDate: day.date]];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor todayColor];
    } else {
        cell.backgroundColor = [UIColor newEventColor];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JERCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    _expandingCellFrame = CGRectMake(cell.frame.origin.x + collectionView.frame.origin.x, cell.frame.origin.y + collectionView.frame.origin.y - collectionView.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    
    JERDay *day = [_datesToDisplay objectAtIndex:indexPath.item];
    JERTodayViewController *dayViewController = [[JERTodayViewController alloc] initWithReadOnly];
    
    if (![day.events count]) {
        PFQuery *todaysEventsQuery = [JEREvent query];
        [todaysEventsQuery whereKey:@"date" equalTo:day.date];
        [todaysEventsQuery whereKey:@"user" equalTo:day.user];
        [day addEventsFromArray:[todaysEventsQuery findObjects]];
    }
    dayViewController.today = day;
    _expandingCell = [[UIView alloc] initWithFrame:_expandingCellFrame];
    _expandingCell.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_expandingCell];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_expandingCell setBackgroundColor:[UIColor todayColor]];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            [self.view bringSubviewToFront:_expandingCell];
            _expandingCell.frame = self.view.bounds;
            
        } completion:^(BOOL finished) {
            [self presentViewController:dayViewController animated:NO completion:NULL];
        }];
    }];
    
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
        }];
    }];
}

-(BOOL)shouldAutorotate {
    return false;
}

@end
