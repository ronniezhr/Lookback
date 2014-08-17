//
//  JEREventBoardViewController.h
//  Lookback
//
//  Created by Jooeun Lim on 7/14/14.
//

#import <UIKit/UIKit.h>

@interface JEREventBoardViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    UICollectionView *_collectionView;
}

@end
