//
//  JERAddEventViewController.m
//  Lookback
//
//  Created by Jooeun Lim on 7/14/14.
//

#import "JERAddEventViewController.h"

#import <stdlib.h>

#import <UIKit/UIKit.h>

#import "JEREvent.h"
#import "JEREventBoardViewController.h"
#import "JERImageStore.h"
#import "Parse/Parse.h"
#import "UIColor+JERColors.h"
#import "UIFont+JERFonts.h"
#import "JERBackButtonView.h"

static const NSString *descriptionPlaceholderText = @"describe your event...";

@interface JERAddEventViewController () {
    UITextField *_titleText;
    UILabel *_dateLabel;
    UILabel *_timeLabel;
    
    UIButton *_saveButton;
    JERBackButtonView *_backButton;
    UIButton *_takePhoto;
    UIButton *_choosePhotoButton;
    
    UIImageView *_imageView;
    UITextView *_textView;
    UIImagePickerController *_imagePicker;
    
    NSDate *_date;
    BOOL _readOnly;
    
    
}

@end

@implementation JERAddEventViewController

- (instancetype)init
{
    
    if (!(self = [super init])) {
        return nil;
    }
    _titleText = [[UITextField alloc] init];
    _titleText.placeholder = @"Untitled Event";
    _titleText.delegate = self;
    _titleText.textAlignment = UITextAlignmentCenter;
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    _date = [[NSCalendar currentCalendar]
             dateFromComponents:components];
    
    _saveButton = [[UIButton alloc] init];
    [_saveButton setTitle:@"save" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont lookbackHeaderFont];
    [_saveButton setBackgroundColor:[UIColor lookBackColor]];
    [_saveButton addTarget:self action:@selector(doneAdding:) forControlEvents:UIControlEventTouchUpInside];
    
    _imageView = [[UIImageView alloc] init];
    _imagePicker.delegate = self;
    
    _takePhoto = [[UIButton alloc] init];
    [_takePhoto setTitle:@" take photo " forState:UIControlStateNormal];
    _takePhoto.titleLabel.font = [UIFont lookbackRegularFont];
    [_takePhoto addTarget:self action:@selector(takePicture: ) forControlEvents:UIControlEventTouchUpInside];
    
    _choosePhotoButton = [[UIButton alloc] init];
    [_choosePhotoButton setTitle:@" select photo " forState:UIControlStateNormal];
    _choosePhotoButton.titleLabel.font = [UIFont lookbackRegularFont];
    [_choosePhotoButton addTarget:self action:@selector(takePicture: ) forControlEvents:UIControlEventTouchUpInside];
    
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    
    _titleText.alpha = 0;
    _textView.alpha = 0;
    _imageView.alpha = 0;
    _choosePhotoButton.alpha = 0;
    _takePhoto.alpha = 0;
    _backButton.alpha = 0;
    _saveButton.alpha = 0;
    
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
    
    if (!self.event){
        self.event = [JEREvent object];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped: )];
    tapRecognizer.numberOfTapsRequired = 1;
    
    self.view.backgroundColor = [UIColor newEventColor];
    
    _backButton = [[JERBackButtonView alloc] init];
    _backButton.transform = CGAffineTransformMakeRotation(M_PI / -2);
    CGSize backButtonSize = [_backButton sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    _backButton.frame = CGRectMake(15, 25, backButtonSize.width, backButtonSize.height);
    _backButton.color = [UIColor backgroundColor];
    [_backButton addTarget:self action:@selector(cancelAdding:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    
    CGFloat padding = 0.0f;

    [_textView.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [_textView setBackgroundColor:[[UIColor backgroundColor] colorWithAlphaComponent:0.7f]];
    [_textView setFont:[UIFont lookbackRegularFont]];
    CGFloat textX = 10.0f;
    CGFloat textY = 45.0f;
    padding += textY;
    CGSize textViewSize;
    _textView.text = self.event.text;

    _titleText.text = self.event.title;
    if ([_titleText.text length] == 0) {
        _titleText.font = [UIFont lookbackItalicFont:30.0f];
    } else {
        _titleText.font = [UIFont lookbackHeaderFont];
    }
    
    CGSize nameSize = [_titleText sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat nameX = roundf( (self.view.bounds.size.width - nameSize.width) / 2.0f );
    CGFloat nameY = 30.0f;
    CGRect nameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    _titleText.frame = nameFrame;
    
    if (!_readOnly) {
        textViewSize = CGSizeMake(self.view.bounds.size.width - 20, self.view.bounds.size.height / 4.0f);
        CGRect textFrame = CGRectMake(textX, textY + 40, textViewSize.width, textViewSize.height);
        _textView.frame = textFrame;
        if ([_textView.text length] == 0) {
            _textView.font = [UIFont lookbackItalicFont:20.0f];
            _textView.textColor = [UIColor lightGrayColor];
            _textView.text = descriptionPlaceholderText;
        }
        
    } else {
        textViewSize = [_textView sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
        _textView.editable = NO;
        CGRect textFrame = CGRectMake(textX, textY + 40, self.view.bounds.size.width - 20, textViewSize.height);
        _textView.frame = textFrame;
        _titleText.enabled = NO;
    }
    
    CGFloat saveX = 0.0f;
    CGFloat saveY = self.view.bounds.size.height - 60.0f;
    CGRect doneFrame = CGRectMake(saveX, saveY, self.view.bounds.size.width, 60.0f);
    _saveButton.frame = doneFrame;
    
    CGSize takePhotoSize = [_takePhoto sizeThatFits:(CGSizeMake(FLT_MAX, FLT_MAX))];
    CGFloat takeX = self.view.bounds.size.width - takePhotoSize.width - 10;
    CGFloat takeY = saveY - 50.0f;
    CGRect takeFrame = CGRectMake(takeX, takeY, takePhotoSize.width, takePhotoSize.height);
    _takePhoto.frame = takeFrame;
    [_takePhoto setBackgroundColor:[[UIColor todayColor] colorWithAlphaComponent:0.8f]];
    
    CGSize choosePhotoSize = [_choosePhotoButton sizeThatFits:(CGSizeMake(FLT_MAX, FLT_MAX))];
    CGFloat chooseX = 10;
    CGFloat chooseY = saveY - 50.0f;
    CGRect chooseFrame = CGRectMake(chooseX, chooseY, choosePhotoSize.width, choosePhotoSize.height);
    _choosePhotoButton.frame = chooseFrame;
    [_choosePhotoButton setBackgroundColor:[[UIColor todayColor] colorWithAlphaComponent:0.8f]];
    
    if (!_readOnly) {
        padding += doneFrame.size.height + chooseFrame.size.height;
        [self.view addSubview:_takePhoto];
        [self.view addSubview:_choosePhotoButton];
        [self.view addSubview:_saveButton];
    }

    CGFloat imageX = textX + 25.0f;
    CGFloat imageY = textY + textViewSize.height + 50.0f;
    padding += 50.0f;
    CGRect imageFrame = CGRectMake(imageX, imageY, self.view.bounds.size.width - 70.0f, self.view.frame.size.height - _titleText.frame.size.height - _textView.frame.size.height - padding - 10.0f);
    _imageView.frame = imageFrame;

    if (self.event.photoID) {
        _imageView.image = self.event.image;
    }

    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addSubview:_titleText];
    [self.view addSubview:_backButton];
    [self.view addSubview:_imageView];
    [self.view addSubview:_textView];
    

    [UIView animateWithDuration:.3 animations:^{
        _titleText.alpha = 1;
        _textView.alpha = 1;
        _imageView.alpha = 1;
        _choosePhotoButton.alpha = 1;
        _takePhoto.alpha = 1;
        _backButton.alpha = 1;
        _saveButton.alpha = 1;
    }];
    [self.view bringSubviewToFront:_backButton];
}

- (void)doneAdding:(id)sender {
    self.event.date = _date;
    self.event.text = _textView.text;
    self.event.title = _titleText.text;
    self.event.user = [PFUser currentUser];
    [self.event saveInBackground];
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (void)cancelAdding:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (void)takePicture:(id)sender {
    _imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && sender == _takePhoto) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    _imagePicker.delegate = self;
    [self presentModalViewController:_imagePicker animated:YES];
}

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    _imageView.image = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)uploadImage:(NSData *)imageData {
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *userPhoto = [PFObject objectWithClassName:@"JERPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [userPhoto setObject:[PFUser currentUser] forKey:@"user"];
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                self.event.photoID = [userPhoto objectId];
                [self.event saveInBackground];
            }];
        }
    } progressBlock:NULL];
}

- (BOOL)textViewShouldReturn:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length + (string.length - range.length) > 0){
        textField.font = [UIFont lookbackHeaderFont];
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 15) ? NO : YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:descriptionPlaceholderText]) {
        textView.text = @"";
        textView.font = [UIFont lookbackRegularFont];
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

-(BOOL)shouldAutorotate {
    return false;
}

@end
