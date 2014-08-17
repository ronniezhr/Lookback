
#import "JERPeriodViewController.h"
#import "JERPlotViewController.h"
#import "UIColor+JERColors.h"
#import "UIFont+JERFonts.h"
#import "Parse/Parse.h"
#import "JERDay.h"
#import "JERBackButtonView.h"

@interface JERPeriodViewController ()
{
    UIDatePicker *_beginDate;
    UIDatePicker *_endDate;
    UIButton *_button;
    UILabel *_buttonLabel;
    JERBackButtonView *_exitButton;
}

@end

@implementation JERPeriodViewController

#pragma mark - init view methods
- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _beginDate = [[UIDatePicker alloc] init];
    _beginDate.datePickerMode = UIDatePickerModeDate;
    _endDate = [[UIDatePicker alloc] init];
    _endDate.datePickerMode = UIDatePickerModeDate;
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setBackgroundImage:[UIImage imageNamed:@"graphButton.png"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttonLabel = [[UILabel alloc] init];
    [_buttonLabel setText:@"view graph"];
    [_buttonLabel setFont:[UIFont lookbackBoldFontWithSize:22.0f]];
    [_buttonLabel setTextColor:[UIColor lookBackColor]];
    
    _beginDate.alpha = 0;
    _endDate.alpha = 0;
    _button.alpha = 0;
    _exitButton.alpha = 0;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor newEventColor];
    
    CGSize beginDateSize = [_beginDate sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat beginDateX = roundf( (self.view.bounds.size.width - beginDateSize.width) / 2.0f );
    CGFloat beginDateY = 50;
    CGRect beginDateFrame = CGRectMake(beginDateX, beginDateY, beginDateSize.width, beginDateSize.height);
    _beginDate.frame = beginDateFrame;
    
    CGSize endDateSize = [_endDate sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat endDateX = roundf( (self.view.bounds.size.width - endDateSize.width) / 2.0f );
    CGFloat endDateY = beginDateY + beginDateSize.height;
    CGRect endDateFrame = CGRectMake(endDateX, endDateY, endDateSize.width, endDateSize.height);
    _endDate.frame = endDateFrame;
    
    CGSize goButtonSize = [_button sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat goX = roundf((self.view.bounds.size.width - goButtonSize.width) / 2.0f);
    CGFloat goY = roundf(endDateY + endDateSize.height);
    CGRect goFrame = CGRectMake(goX, goY - 20.0f, goButtonSize.width, goButtonSize.height);
    _button.frame = goFrame;
    
    CGSize labelSize = [_buttonLabel sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    goFrame.origin.x += roundf((goFrame.size.width - labelSize.width) / 2.0f);
    _buttonLabel.frame = goFrame;
    
    _exitButton = [[JERBackButtonView alloc] init];
    CGSize backButtonSize = [_exitButton sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    _exitButton.frame = CGRectMake(15, 25, backButtonSize.width, backButtonSize.height);
    _exitButton.color = [UIColor backgroundColor];
    [_exitButton addTarget:self action:@selector(exitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitButton];
    
    PFQuery *query = [PFQuery queryWithClassName:@"JERDay"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query addAscendingOrder:@"date"];
    
    JERDay *firstDay = [query getFirstObject];
    NSDate *maxDate =[NSDate date];
    _beginDate.minimumDate = firstDay.date;
    _beginDate.maximumDate = maxDate;
    [_beginDate setDate:firstDay.date];
    _endDate.minimumDate = firstDay.date;
    _endDate.maximumDate = maxDate;
    [_endDate setDate:maxDate];
    
    [self.view addSubview:_beginDate];
    [self.view addSubview:_endDate];
    [self.view addSubview:_button];
    [self.view addSubview:_exitButton];
    [self.view addSubview:_buttonLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        _beginDate.alpha = 1;
        _endDate.alpha = 1;
        _exitButton.alpha = 1;
        _button.alpha = 1;
    }];
}

- (void)exitTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (void)buttonTapped:(id)sender
{
    JERPlotViewController *plotViewController = [[JERPlotViewController alloc] init];
    plotViewController.beginDate = [_beginDate date];
    plotViewController.endDate = [_endDate date];
    [UIView animateWithDuration:0.5f animations:^{
        _endDate.alpha = 0;
        _beginDate.alpha = 0;
        _button.alpha = 0;
        _exitButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self presentViewController:plotViewController animated:YES completion:NULL];
    }];
    
}

-(BOOL)shouldAutorotate {
    return false;
}

@end
