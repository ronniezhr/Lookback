//
//  JERCollectionViewCell.m
//  Lookback
//
//  Created by Emily Scharff on 7/14/14.
//

#import "JERCollectionViewCell.h"
#import "UIColor+JERColors.h"
#import "UIFont+JERFonts.h"

@interface JERCollectionViewCell () {
    UIImageView *_eventImageView;
    UILabel *_descriptionLabel;
}

@end

@implementation JERCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _eventImageView = [[UIImageView alloc] init];
        [_eventImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_eventImageView];
    }
    return self;
}

- (void)setDescription:(NSString *)description
{
    _descriptionLabel = [[UILabel alloc] init];
    _description = [description copy];
    _descriptionLabel.text = _description;
    _descriptionLabel.font = [UIFont lookbackFontWithSize:15];
    CGSize descriptionLabelSize = [_descriptionLabel sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat descriptionLabelX = roundf((self.cellSize.width-descriptionLabelSize.width)/2.0f);
    CGFloat descriptionLabelY = roundf((self.cellSize.height-descriptionLabelSize.height)/2.0f);
    CGRect descriptionLabelFrame = CGRectMake(descriptionLabelX, descriptionLabelY, descriptionLabelSize.width, descriptionLabelSize.height);
    _descriptionLabel.frame = descriptionLabelFrame;
    _descriptionLabel.adjustsFontSizeToFitWidth = YES;
    [_descriptionLabel setTextColor:[UIColor whiteColor]];

    [self.contentView addSubview:_descriptionLabel];
    
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.contentView.bounds;
    [self.contentView insertSubview:imageView
                            atIndex:0];
    return;
}

- (void)layoutSubviews
{
    [_eventImageView sizeToFit];
    [_descriptionLabel sizeToFit];
}

@end
