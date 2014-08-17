//
//  JERSignUpViewController.m
//  Lookback
//
//  Created by Jooeun Lim on 7/17/14.
//

#import "JERSignUpViewController.h"

#import "UIColor+JERColors.h"
#import "UIFont+JERFonts.h"
#import "UIImage+JERImages.h"

@interface JERSignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation JERSignUpViewController

@synthesize fieldsBackground;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.signUpView setBackgroundColor:[[UIColor newEventColor] colorWithAlphaComponent:0.7f]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appNameIcon.png"]]];
    
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    
    [self.signUpView.usernameField setTextColor:[UIColor blackColor]];
    [self.signUpView.usernameField setPlaceholder:@"username"];
    [self.signUpView.usernameField setFont:[UIFont lookbackRegularFont]];
    [self.signUpView.passwordField setTextColor:[UIColor blackColor]];
    [self.signUpView.passwordField setFont:[UIFont lookbackRegularFont]];
    [self.signUpView.passwordField setPlaceholder:@"password"];
    [self.signUpView.emailField setTextColor:[UIColor blackColor]];
    [self.signUpView.emailField setFont:[UIFont lookbackRegularFont]];
    [self.signUpView.emailField setPlaceholder:@"email"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.signUpView.dismissButton setFrame:CGRectMake(20.0f, 30.0f, self.signUpView.dismissButton.frame.size.width, self.signUpView.dismissButton.frame.size.height)];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage lookbackImageWithColor:[[UIColor appNameColor] colorWithAlphaComponent:0.7f]] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage lookbackImageWithColor:[UIColor newEventColor]] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton.titleLabel setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self.signUpView.signUpButton.titleLabel setFont:[UIFont lookbackFontWithSize:18.0f]];
    
    [self.signUpView.signUpButton setFrame:CGRectMake(self.signUpView.signUpButton.frame.origin.x, self.view.frame.size.height - self.signUpView.signUpButton.frame.size.height - 50.0f, self.signUpView.signUpButton.frame.size.width, self.signUpView.signUpButton.frame.size.height)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return false;
}

@end
