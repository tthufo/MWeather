//
//  PC_Wind_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/16/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Wind_Cell.h"

@import Charts;

#import "DateValueFormatter.h"

#include <math.h>

@interface PC_Wind_Cell ()<ChartViewDelegate>
{
    IBOutlet UIButton * daily, * weekLy;
        
    BOOL day;
}

@property (nonatomic, strong) IBOutlet BarChartView *chartView;

@end

@implementation PC_Wind_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];

    [self optional];
}

- (IBAction)didPressOption:(UIButton*)button {
    day = button.tag != 11;
    [self optional];
}

- (void)optional {
    [daily withBorder:@{@"Bcolor": [self color: @"#5530F5"], @"Bground": [self color: !day ? @"#5530F5" : @"#FFFFFF"], @"Bwidth": !day ? @"1" : @"0", @"Bcorner": @"16"}];
    [weekLy withBorder:@{@"Bcolor": [self color: @"#5530F5"], @"Bground": [self color: !day ? @"#FFFFFF" : @"5530F5"], @"Bwidth": !day ? @"0" : @"1", @"Bcorner": @"16"}];
    
    [daily setTitleColor:[self color: !day ? @"#FFFFFF" : @"#5530F5"] forState:UIControlStateNormal];
    [weekLy setTitleColor:[self color: !day ? @"#5530F5" : @"#FFFFFF"] forState:UIControlStateNormal];
}

- (UIColor*)color:(NSString*)color {
    return [AVHexColor colorWithHexString:color];
}

- (NSString*)returnValue:(NSString*)key {
            
    NSDictionary * currently = data[@"currently"];

    double tempo = [[self getValue:@"deg"] isEqualToString:@"0"] ? [[currently getValueFromKey:key] doubleValue] : ([[currently getValueFromKey:key] doubleValue] * 9/5) + 32;

    NSString * value = [NSString stringWithFormat:@"%.f", ceil(tempo)];
    
    return value;
}

- (NSString*)returnValueH:(NSDictionary*)currently {
                
    NSString * key = @"temperature";

    double tempo = [[self getValue:@"deg"] isEqualToString:@"0"] ? [[currently getValueFromKey:key] doubleValue] : ([[currently getValueFromKey:key] doubleValue] * 9/5) + 32;

    NSString * value = [NSString stringWithFormat:@"%.f", ceil(tempo)];
    
    return value;
}

- (void)prepareForReuse {
    [super prepareForReuse];
        
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy"];
//    NSString *year = [formatter stringFromDate:[NSDate date]];
//
    NSDictionary * currently = data[@"currently"];
//
//    date.text = [[currently getValueFromKey:@"time"] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", year] withString:@""];
//
//    temprature.text = [self returnValue:@"temperature"];
//
//    unit.text = [[self getValue:@"deg"] isEqualToString:@"0"] ? @"°C" : @"°F";
//
//    up.text = [NSString stringWithFormat:@"%@°↑", [self returnValue:@"temperatureHigh"]];
//
//    down.text = [NSString stringWithFormat:@"%@°↓", [self returnValue:@"temperatureLow"]];
//
//    current.text = [NSString stringWithFormat:@"Thực tế ~ %@°", [self returnValue:@"apparentTemperature"]];
//
//    state.image = [UIImage imageNamed:[[currently getValueFromKey: @"icon"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
//
//    dataSource = [@[] mutableCopy];
//
//    titles = [@[] mutableCopy];

    [self setupBarLineChartView:_chartView];

      _chartView.delegate = self;
   
   _chartView.drawBarShadowEnabled = NO;
   _chartView.drawValueAboveBarEnabled = YES;
   
   _chartView.maxVisibleCount = 60;
   
   ChartXAxis *xAxis = _chartView.xAxis;
   xAxis.labelPosition = XAxisLabelPositionBottom;
   xAxis.labelFont = [UIFont systemFontOfSize:10.f];
   xAxis.drawGridLinesEnabled = NO;
   xAxis.granularity = 1.0; // only intervals of 1 day
   xAxis.labelCount = 7;
//   xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:_chartView];
   
   NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
   leftAxisFormatter.minimumFractionDigits = 0;
   leftAxisFormatter.maximumFractionDigits = 1;
   leftAxisFormatter.negativeSuffix = @" $";
   leftAxisFormatter.positiveSuffix = @" $";
   
   ChartYAxis *leftAxis = _chartView.leftAxis;
   leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
   leftAxis.labelCount = 8;
   leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
   leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
   leftAxis.spaceTop = 0.15;
   leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
   
   ChartYAxis *rightAxis = _chartView.rightAxis;
   rightAxis.enabled = YES;
   rightAxis.drawGridLinesEnabled = NO;
   rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
   rightAxis.labelCount = 8;
   rightAxis.valueFormatter = leftAxis.valueFormatter;
   rightAxis.spaceTop = 0.15;
   rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
   
   ChartLegend *l = _chartView.legend;
   l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
   l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
   l.orientation = ChartLegendOrientationHorizontal;
   l.drawInside = NO;
   l.form = ChartLegendFormSquare;
   l.formSize = 9.0;
   l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
   l.xEntrySpace = 4.0;
   
//   XYMarkerView *marker = [[XYMarkerView alloc]
//                                 initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
//                                 font: [UIFont systemFontOfSize:12.0]
//                                 textColor: UIColor.whiteColor
//                                 insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
//                                 xAxisValueFormatter: _chartView.xAxis.valueFormatter];
//   marker.chartView = _chartView;
//   marker.minimumSize = CGSizeMake(80.f, 40.f);
//   _chartView.marker = marker;
    
    [self updateChartData];
}

- (void)updateChartData
{
    [self setDataCount:45 range:100];
}

- (NSDate*)date:(NSString*)dateString
{
    return [dateString dateWithFormat:@"HH:mm dd/MM/yyyy"];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        NSTimeInterval now = [[self date:data[@"hourly"][i][@"time"]] timeIntervalSince1970];
        
        double val = [[self returnValueH:data[@"hourly"][i]] doubleValue];
        [values addObject:[[BarChartDataEntry alloc] initWithX:now y:val icon: [UIImage imageNamed:@"trans"]]];
        
//        double val = [[[data[@"hourly"][i][@"time"] componentsSeparatedByString:@" "] firstObject] doubleValue];
//        [values addObject:[[ChartDataEntry alloc] initWithX:val y:[[self returnValue:data[@"hourly"][i][@"temperature"]] doubleValue] icon: [UIImage imageNamed:@"trans"]]];
    }
    
    BarChartDataSet *set1 = nil;
      if (_chartView.data.dataSetCount > 0)
      {
          set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
          [set1 replaceEntries: values];
          [_chartView.data notifyDataChanged];
          [_chartView notifyDataSetChanged];
      }
      else
      {
          set1 = [[BarChartDataSet alloc] initWithEntries:values label:@""];
          [set1 setColors: @[[UIColor redColor]]];
          set1.drawIconsEnabled = NO;
          
          NSMutableArray *dataSets = [[NSMutableArray alloc] init];
          [dataSets addObject:set1];
          
          BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
          [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
          
          data.barWidth = 0.9f;
          
          _chartView.data = data;
      }
    
//    LineChartDataSet *set1 = nil;
//    if (_chartView.data.dataSetCount > 0)
//    {
//        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
//        [set1 replaceEntries: values];
//        [_chartView.data notifyDataChanged];
//        [_chartView notifyDataSetChanged];
//    }
//    else
//    {
//        set1 = [[LineChartDataSet alloc] initWithEntries:values label:@""];
//
//        set1.highlightColor = [UIColor clearColor];
//        set1.drawIconsEnabled = NO;
//        set1.lineWidth = 1.0;
//        set1.circleRadius = 3.0;
//        set1.drawCircleHoleEnabled = NO;
//        set1.valueFont = [UIFont systemFontOfSize:9.f];
//        set1.formLineDashLengths = @[@5.f, @2.5f];
//        set1.formLineWidth = 1.0;
//        set1.formSize = 15.0;
//
//        NSArray *gradientColors = @[
//                                    (id)[ChartColorTemplates colorFromString:@"#78A6E5"].CGColor,
//                                    (id)[ChartColorTemplates colorFromString:@"#FFFFFF"].CGColor
//                                    ];
//        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
//
//        set1.fillAlpha = 1.f;
//        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
//        set1.drawFilledEnabled = YES;
//
//        CGGradientRelease(gradient);
//
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//
//        [dataSets addObject:set1];
//
//        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//
//        _chartView.data = data;
//
//         for (id<ILineChartDataSet> set in _chartView.data.dataSets)
//        {
//            set.drawCirclesEnabled = NO;
//            set.mode = LineChartModeCubicBezier;
//        }
//
//        [_chartView setNeedsDisplay];
}


//- (void)setData
//{
//    _chartView.data = nil;
//
//    NSMutableArray * dataList = [NSMutableArray new];
//
//    for(int o = 0; o < dataSource.count; o++)
//    {
//        NSMutableArray * arr = [[NSMutableArray alloc] init];
//
//
//        for(int i = 0; i < ((NSArray*)dataSource[o][@"Data"]).count; i++)
//        {
////            NSLog(@"%@", dataSource[o][@"Data"][i][@"NgayApDung"]);
//
//            NSTimeInterval now = [[self date:dataSource[o][@"Data"][i][@"NgayApDung"]] timeIntervalSince1970];
//
//            [arr addObject:[[ChartDataEntry alloc] initWithX:now y:[((NSArray*)dataSource[o][@"Data"])[i][@"Gia"] intValue]]];
//        }
//
//        LineChartDataSet *set1 = nil;
//
////        if (_chartView.data.dataSetCount > 0)
////        {
////            set1 = (LineChartDataSet *)_chartView.data.dataSets[o];
////
////            set1.values = arr;
////
////            [_chartView.data notifyDataChanged];
////
////            [_chartView notifyDataSetChanged];
////        }
////        else
//        {
//            set1 = [[LineChartDataSet alloc] initWithValues:arr label:dataSource[o][@"Ten"]];
//            set1.axisDependency = AxisDependencyLeft;
//            [set1 setColor:[self getRandomColor]];//[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
//            [set1 setCircleColor:UIColor.darkGrayColor];
//            set1.lineWidth = 2.0;
//            set1.circleRadius = 4.0;
//            set1.fillAlpha = 65/255.0;
//            set1.fillColor = [self getRandomColor];//[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
//            set1.highlightColor = [self getRandomColor];//[UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//            set1.drawCircleHoleEnabled = NO;
//        }
//
//        [dataList addObject:set1];
//    }
//
//    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataList];
//    [data setValueTextColor:UIColor.blackColor];
//    [data setValueFont:[UIFont systemFontOfSize:9.f]];
//
//    [_chartView.data notifyDataChanged];
//    [_chartView notifyDataSetChanged];
//
//    _chartView.data = data;
//}

#pragma mark - ChartViewDelegate

//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    NSLog(@"chartValueSelected");
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    NSLog(@"chartValueNothingSelected");
//}

- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;
    
    // ChartYAxis *leftAxis = chartView.leftAxis;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
@end
