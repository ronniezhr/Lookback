//
//  UIImage+JERImages.m
//  Lookback
//
//  Created by Jooeun Lim on 8/12/14.
//

#import "UIImage+JERImages.h"

@implementation UIImage (JERImages)

+ (UIImage *)lookbackImageWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, frame);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
