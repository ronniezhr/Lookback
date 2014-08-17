//
//  UIColor+JERColors.m
//  Lookback
//
//  Created by Emily Scharff on 7/31/14.
//

#import "UIColor+JERColors.h"

@implementation UIColor (JERColors)

+ (UIColor *)titleColor
{
    return [UIColor colorWithRed:245.0/255.0 green:151.0/255.0 blue:125.0/255.0 alpha:1.0f];
}

+ (UIColor *)appNameColor
{
    return [UIColor colorWithRed:245.0/255.0 green:151.0/255.0 blue:125.0/255.0 alpha:1.0f];
}

+ (UIColor *)todayColor
{
    return [UIColor colorWithRed:250.0/255.0 green:174.0/255.0 blue:99.0/255.0 alpha:1.0f];
}

+ (UIColor *)newEventColor
{
    return [UIColor colorWithRed: 155.0/255.0 green:221.0/255.0 blue:247.0/255.0 alpha:1.0f];

}

+ (UIColor *)lookBackColor
{
    return [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0f];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:254.0/255.0 green:240.0/255.0 blue:211.0/255.0 alpha:1.0f];
}

+ (UIColor *)boxBackgroundColor
{
    return [UIColor colorWithWhite:1.0 alpha:0.2];
}

+ (UIColor *)boxBorderColor {
    return [UIColor colorWithRed:235.0/255.0 green:70.0/255.0 blue:196.0/255.0 alpha:1.0f];
}

@end
