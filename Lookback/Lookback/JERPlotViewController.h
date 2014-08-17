
#import <Foundation/Foundation.h>

#import "CorePlot-CocoaTouch.h"

@interface JERPlotViewController : UIViewController<CPTPlotDataSource>

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@end
