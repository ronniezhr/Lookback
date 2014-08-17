
#import "JEREmojiImage.h"

#import <QuartzCore/QuartzCore.h>

#import "UIColor+JERColors.h"

@implementation JEREmojiImage

+ (UIImage *)imageWithEmoji:(NSString *)emoji withSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Apple Color Emoji" size:size];
    label.text = emoji;
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    CGSize labelSize = CGSizeMake(size, size);
    label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);

    return [JEREmojiImage imageFromView:label];
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsPushContext(UIGraphicsGetCurrentContext());
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsPopContext();
    return img;
}

@end
