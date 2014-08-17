//
//  JERBackButtonView.m
//  Lookback
//
//  Created by Emily Scharff on 8/12/14.
//

#import "JERBackButtonView.h"

@interface JERBackButtonView ()
@property (nonatomic, strong) UIImageView *maskView;
@end

@implementation JERBackButtonView

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    self.maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backButton"]];
    self.layer.mask = self.maskView.layer;
    return self;
}

- (void)setColor:(UIColor *)color
{
    self.backgroundColor = color;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [_maskView sizeThatFits:size];
}

@end
