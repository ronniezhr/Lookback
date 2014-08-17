//
//  JERLogInViewController.m
//  Lookback
//
//  Created by Jooeun Lim on 7/17/14.
//

#import "JERLogInViewController.h"
#import "UIFont+JERFonts.h"
#import "UIColor+JERColors.h"
#import "UIImage+JERImages.h"

@interface JERLogInViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation JERLogInViewController

@synthesize fieldsBackground;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[[UIColor appNameColor] colorWithAlphaComponent:0.5f]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appNameIcon.png"]]];
    
    [self.logInView.usernameField setTextColor:[UIColor blackColor]];
    [self.logInView.usernameField setBackgroundColor:[UIColor backgroundColor]];
    [self.logInView.usernameField setFont:[UIFont lookbackRegularFont]];
    self.logInView.usernameField.layer.borderColor = [UIColor appNameColor].CGColor;
    self.logInView.usernameField.layer.borderWidth = 1.0f;
    self.logInView.usernameField.placeholder = @"username";
    
    [self.logInView.passwordField setTextColor:[UIColor blackColor]];
    [self.logInView.passwordField setBackgroundColor:[UIColor backgroundColor]];
    [self.logInView.passwordField setFont:[UIFont lookbackRegularFont]];
    self.logInView.passwordField.layer.borderColor = [UIColor appNameColor].CGColor;
    self.logInView.passwordField.layer.borderWidth = 1.0f;
    self.logInView.passwordField.placeholder = @"password";
    
    self.logInView.dismissButton.hidden = YES;
    
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.logInView.logInButton setFrame:CGRectMake(self.logInView.passwordField.frame.origin.x, self.logInView.passwordField.frame.origin.y + self.logInView.passwordField.frame.size.height + 50.0f, self.logInView.passwordField.frame.size.width, self.logInView.logInButton.frame.size.height)];
    
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage lookbackImageWithColor:[UIColor appNameColor]] forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage lookbackImageWithColor:[UIColor backgroundColor]] forState:UIControlStateHighlighted];
    
    [self.logInView.logInButton setBackgroundImage:[UIImage lookbackImageWithColor:[[UIColor appNameColor] colorWithAlphaComponent:0.5f]] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage lookbackImageWithColor:[UIColor newEventColor]] forState:UIControlStateHighlighted];
    [self.logInView.logInButton.titleLabel setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self.logInView.logInButton.titleLabel setFont:[UIFont lookbackFontWithSize:18.0f]];

    [self.logInView.signUpButton setBackgroundImage:[UIImage lookbackImageWithColor:[[UIColor newEventColor] colorWithAlphaComponent:0.7f]] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage lookbackImageWithColor:[UIColor appNameColor]] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton.titleLabel setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self.logInView.signUpButton.titleLabel setFont:[UIFont lookbackFontWithSize:18.0f]];

    [self.logInView.signUpButton setFrame:CGRectMake(0.0f, self.view.frame.size.height - self.logInView.logInButton.frame.size.height - 20.0f, self.view.frame.size.width, self.logInView.logInButton.frame.size.height + 20.0f)];
    
    self.logInView.signUpLabel.text = @"";
    UILabel *signUpQuestionLabel = [[UILabel alloc] init];
    [signUpQuestionLabel setText:@"No account?"];
    [signUpQuestionLabel setFont:[UIFont lookbackFontWithSize:15.0f]];
    [signUpQuestionLabel setTextColor:[UIColor backgroundColor]];
    CGSize questionLabelSize = [signUpQuestionLabel sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGRect questionFrame = CGRectMake((self.view.frame.size.width - questionLabelSize.width) / 2.0, self.logInView.signUpButton.frame.origin.y - questionLabelSize.height - 10.0f, questionLabelSize.width, questionLabelSize.height);
    signUpQuestionLabel.frame = questionFrame;
    [self.view addSubview:signUpQuestionLabel];
}

-(BOOL)shouldAutorotate {
    return false;
}

@end
