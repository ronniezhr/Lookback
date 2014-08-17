
#import "JERMainPageViewController.h"
#import "JERAddEventViewController.h"
#import "JEREventBoardViewController.h"
#import "JERPeriodViewController.h"
#import "JERTodayViewController.h"
#import "JERLogInViewController.h"
#import "JERSignUpViewController.h"
#import "UIColor+JERColors.h"
#import "UIFont+JERFonts.h"

static const float animationSpeed = 0.5f;

@interface JERMainPageViewController ()
{
    UIButton *_eventBoard;
    UIButton *_eventView;
    UIButton *_newEvent;
    UIButton *_mainScreen;
    UIButton *_pastEvents;
    UIButton *_todayView;
    UIButton *_searchButton;
    UIButton *_logOutButton;
    UILabel *_appNameLabel;
    CGRect _restoreFrame;
}
@end

@implementation JERMainPageViewController

-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _appNameLabel = [[UILabel alloc] init];
    [_appNameLabel setText:@"l\U0001F440kback"];
    
    _newEvent = [UIButton buttonWithType:UIButtonTypeSystem];
    [_newEvent setTitle:@"+" forState:UIControlStateNormal];
    [_newEvent addTarget:self action:@selector(newEventTapped: ) forControlEvents:UIControlEventTouchUpInside];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:@"past days" forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(eventBoardTapped: ) forControlEvents:UIControlEventTouchUpInside];
    
    _pastEvents = [UIButton buttonWithType:UIButtonTypeSystem];
    [_pastEvents setTitle:@"view graph" forState:UIControlStateNormal];
    [_pastEvents addTarget:self action:@selector(pastEventTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _todayView = [UIButton buttonWithType:UIButtonTypeSystem];
    [_todayView setTitle:@"today" forState:UIControlStateNormal];
    [_todayView addTarget:self action:@selector(todayViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _logOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_logOutButton setBackgroundImage:[UIImage imageNamed:@"logoutButton.png"] forState:UIControlStateNormal];
    [_logOutButton addTarget:self action:@selector(logOutButtonTapped:)forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)todayViewTapped:(id)sender
{
    JERTodayViewController *todayViewController = [[JERTodayViewController alloc] init];
    _restoreFrame = _todayView.frame;
    [UIView animateWithDuration:animationSpeed animations:^{
        [self.view bringSubviewToFront:_todayView];
        _todayView.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        [self presentViewController:todayViewController animated:NO completion:NULL];
    }];
    
}

- (void)pastEventTapped:(id)sender
{
    JERPeriodViewController *periodViewController = [[JERPeriodViewController alloc] init];
    _restoreFrame = _pastEvents.frame;
    [UIView animateWithDuration:animationSpeed animations:^{
        [self.view bringSubviewToFront:_pastEvents];
        _pastEvents.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        [self presentViewController:periodViewController animated:NO completion:NULL];
    }];
}
- (void)newEventTapped:(id)sender
{
    _restoreFrame = _newEvent.frame;
    JERAddEventViewController *newEventController = [[JERAddEventViewController alloc] init];
    [UIView animateWithDuration:animationSpeed animations:^{
        [self.view bringSubviewToFront:_newEvent];
        _newEvent.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        [self presentViewController:newEventController animated:NO completion:NULL];
    }];
}

- (void)eventBoardTapped:(id)sender
{
    JEREventBoardViewController *eventBoardViewController = [[JEREventBoardViewController alloc] init];
    _restoreFrame = _searchButton.frame;
    [UIView animateWithDuration:animationSpeed animations:^{
        [self.view bringSubviewToFront:_searchButton];
        _searchButton.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        [self presentViewController:eventBoardViewController animated:NO completion:NULL];
    }];
}

- (void)logOutButtonTapped:(id)sender
{
    [PFUser logOut];
    [self viewDidAppear:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    if ([self.presentedViewController class] == [JERLogInViewController class]) {
        return;
    }

    [UIView animateWithDuration:animationSpeed animations:^{
        UIButton *expandedButton = self.view.subviews[[self.view.subviews count] - 1];
        expandedButton.frame = _restoreFrame;
        [self.view bringSubviewToFront:expandedButton];
    }];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *defaultFont = [UIFont lookbackHeaderFont];
    CGSize buttonSize = CGSizeMake(self.view.bounds.size.width - 10.0f, self.view.bounds.size.height / 6.0f);
    CGFloat buttonX = roundf( (self.view.bounds.size.width - buttonSize.width + 10.0f) / 2.0f );
    CGFloat buttonY = roundf( (self.view.bounds.size.height - buttonSize.height - 5.0f));
    CGRect buttonFrame = CGRectMake(buttonX / 2.0f, buttonY, buttonSize.width, buttonSize.height);
    
    CGSize graphButtonSize = CGSizeMake(self.view.bounds.size.width - 10.0f, self.view.bounds.size.height / 6.0f);
    CGFloat graphButtonX = roundf( (self.view.bounds.size.width - graphButtonSize.width + 10.0f) / 2.0f );
    CGFloat graphButtonY = roundf(self.view.bounds.size.height - graphButtonSize.height - 5.0f);
    CGRect graphButtonFrame = CGRectMake(graphButtonX / 2.0f, graphButtonY, graphButtonSize.width, graphButtonSize.height);
    _pastEvents.frame = graphButtonFrame;
    _pastEvents.backgroundColor = [UIColor newEventColor];
    [_pastEvents.titleLabel setFont: defaultFont];
    [_pastEvents setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview: _pastEvents];
    
    CGSize labelSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height / 4.0f);
    CGFloat labelX = 0.0f;
    CGFloat labelY = 0.0f;
    CGRect labelFrame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    _appNameLabel.frame = labelFrame;
    _appNameLabel.backgroundColor = [UIColor titleColor];
    [_appNameLabel setFont: [UIFont lookbackBigTitleFont]];
    [_appNameLabel setTextColor: [UIColor whiteColor]];
    _appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: _appNameLabel];
    
    CGFloat midObjYPos = labelY + labelSize.height + 5.0f;
    CGFloat midObjHeight = graphButtonY - midObjYPos - 5.0f;
    CGFloat midObjWidth = self.view.bounds.size.width - 10.0f;
    
    buttonFrame = CGRectMake(buttonX / 2.0f, midObjYPos, (midObjWidth - 5.0f) / 2, midObjHeight);
    _todayView.frame = buttonFrame;
    _todayView.backgroundColor = [UIColor todayColor];
    [_todayView.titleLabel setFont: defaultFont];
    [_todayView setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview: _todayView];
    
    buttonFrame = CGRectMake(_todayView.frame.size.width + 10.0f, midObjYPos, (midObjWidth - 5.0f) / 2.0f, (midObjHeight - 5.0f) / 2.0f);
    _newEvent.frame = buttonFrame;
    _newEvent.backgroundColor = [UIColor newEventColor];
    [_newEvent.titleLabel setFont: [UIFont lookbackBigTitleFont]];
    [_newEvent setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview: _newEvent];
    
    buttonFrame = CGRectMake(_todayView.frame.size.width + 10.0f, midObjYPos + _newEvent.frame.size.height + 5.0f, (midObjWidth - 5.0f) / 2.0f, (midObjHeight - 5.0f) / 2.0f);
    _searchButton.frame = buttonFrame;
    _searchButton.backgroundColor = [UIColor lookBackColor];
    [_searchButton.titleLabel setFont: defaultFont];
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview: _searchButton];

    CGSize logoutSize = [_logOutButton sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGRect logoutFrame = CGRectMake(5.0f, 30.0f, logoutSize.width / 6.0f, logoutSize.height / 6.0f);
    _logOutButton.frame = logoutFrame;
    [self.view addSubview:_logOutButton];
    
    [self.view setBackgroundColor: [UIColor backgroundColor]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        JERLogInViewController *logInViewController = [[JERLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        JERSignUpViewController *signUpViewController = [[JERSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in!");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

-(BOOL)shouldAutorotate {
    return false;
}

@end
