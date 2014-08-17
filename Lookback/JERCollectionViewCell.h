//
//  JERCollectionViewCell.h
//  Lookback
//
//  Created by Emily Scharff on 7/14/14.
//

#import <UIKit/UIKit.h>

@interface JERCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) UIImage *image;
@property CGSize cellSize;

@end
