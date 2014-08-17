
#import "JERPlotViewController.h"

#import "JERDay.h"
#import "Parse/Parse.h"
#import "UIColor+JERColors.h"

@interface JERPlotViewController ()
{
    NSArray *_points;
    NSArray *emoji_choice;
    CPTColor *backgroundColor;
    CPTColor *axisColor;
    float _averageMood;
}

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@end

@implementation JERPlotViewController

@synthesize hostView = hostView_;

#pragma mark - UIViewController lifecycle methods
-(void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapper.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapper];
    emoji_choice = @[@"\U0001F62D", @"\U0001F612", @"\U0001F610", @"\U0001F60A", @"\U0001F60D"];
    backgroundColor = [CPTColor colorWithComponentRed: 155.0/255.0 green:221.0/255.0 blue:247.0/255.0 alpha:1.0f];
    axisColor = [CPTColor colorWithComponentRed:102.0/255.0 green:0 blue:102.0/255.0 alpha:1.0f];

    PFQuery *query = [PFQuery queryWithClassName:@"JERDay"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"date" greaterThanOrEqualTo:_beginDate];
    [query whereKey:@"date" lessThanOrEqualTo:_endDate];
    NSArray *days = [query findObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    days = [days sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    _averageMood = 0;
    for (JERDay *day in days) {
        [arr addObject:day];
        _averageMood = _averageMood + day.mood;
    }
    _averageMood = _averageMood / [arr count];
    _points = [arr copy];
    self.view.backgroundColor = [UIColor newEventColor];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self initPlot];
    self.hostView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.hostView.alpha = 1;
    }];
}

-(void)handleTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - Chart behavior
-(void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost
{
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    self.hostView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.hostView];
}

-(void)configureGraph
{
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    NSString *title = [NSString stringWithFormat:@"Average Mood: %@", emoji_choice[(int)round(_averageMood) - 1]];
    graph.title = title;
    graph.fill = [CPTFill fillWithColor:backgroundColor];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:backgroundColor];
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:backgroundColor];
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor darkGrayColor];
    titleStyle.fontSize = 20.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(10.0f, 10.0f);
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    [graph.plotAreaFrame setPaddingRight:30.0f];
    [graph.plotAreaFrame setPaddingTop:30.0f];
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots
{
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    CPTScatterPlot *newPointPlot = [[CPTScatterPlot alloc] init];
    newPointPlot.dataSource = self;
    CPTColor *newPointColor = [CPTColor redColor];
    [graph addPlot:newPointPlot toPlotSpace:plotSpace];

    CPTMutableLineStyle *newPointLineStyle = [newPointPlot.dataLineStyle mutableCopy];
    newPointLineStyle.lineWidth = 2.5;
    newPointLineStyle.lineColor = newPointColor;
    newPointPlot.dataLineStyle = newPointLineStyle;
    CPTMutableLineStyle *newPointSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    newPointSymbolLineStyle.lineColor = newPointColor;
    CPTPlotSymbol *newPointSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    newPointSymbol.fill = [CPTFill fillWithColor:newPointColor];
    newPointSymbol.lineStyle = newPointSymbolLineStyle;
    newPointSymbol.size = CGSizeMake(6.0f, 6.0f);
    newPointPlot.plotSymbol = newPointSymbol;

    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-2.1) length:CPTDecimalFromDouble(4.2)] mutableCopy];
    plotSpace.globalYRange = yRange;

    [plotSpace scaleToFitPlots:[NSArray arrayWithObject:newPointPlot]];
}

-(void)configureAxes
{
    // Set styles for plot
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = axisColor;
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = axisColor;
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = axisColor;
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = axisColor;
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = axisColor;
    gridLineStyle.lineWidth = 1.0f;

    // Configure x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Day";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 25.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 10.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = [_points count];

    // Set x-axis label and location
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd"];
    for (JERDay *day in _points) {
        NSString *dateLabel = [formatter stringFromDate:day.date];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:dateLabel  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:@(location)];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;

    // Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Mood";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -50.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
    labelTextStyle.fontName = @"Helvetica-Bold";
    labelTextStyle.fontSize = 35.0f;
    y.labelTextStyle = labelTextStyle;
    y.labelOffset = 40.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 8.0f;
    y.minorTickLength = 4.0f;
    y.tickDirection = CPTSignPositive;

    // Set y-axis label and location
    NSInteger minorIncrement = 1;
    CGFloat yMin = -2.0f;
    CGFloat yMax = 2.0f;             // assume mood is 1 to 5
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = yMin; j <= yMax; j += minorIncrement) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:emoji_choice[j + 2] textStyle:y.labelTextStyle];
        NSDecimal location = CPTDecimalFromInteger(j);
        label.tickLocation = location;
        label.offset = -y.minorTickLength - y.labelOffset;
        if (label) {
            [yLabels addObject:label];
        }
        [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
    }
    y.axisLabels = yLabels;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_points count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSInteger valueCount = [_points count];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                return @(index);
            }
            break;

        case CPTScatterPlotFieldY:
            NSLog(@"Plot points");
            JERDay *day = _points[index];
            return @(day.mood - 3);
            break;
    }
    return [NSDecimalNumber zero];
}

@end
