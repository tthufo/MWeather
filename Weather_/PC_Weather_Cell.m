//
//  PC_Weather_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Weather_Cell.h"

#import "DateValueFormatter.h"

#include <math.h>

@import Charts;

@interface PC_Weather_Cell ()<ChartViewDelegate>
{
    NSMutableArray * dataSource, * titles;
    
    IBOutlet UILabel * date, * temprature, * unit, * up, * down, * current, * rainy;
    
    IBOutlet UIImageView * state;
}

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@end

@implementation PC_Weather_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];
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
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary * currently = data[@"currently"];

    date.text = [[currently getValueFromKey:@"time"] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", year] withString:@""];
    
    temprature.text = [self returnValue:@"temperature"];
    
    unit.text = [[self getValue:@"deg"] isEqualToString:@"0"] ? @"°C" : @"°F";
    
    up.text = [NSString stringWithFormat:@"%@°↑", [self returnValue:@"temperatureHigh"]];

    down.text = [NSString stringWithFormat:@"%@°↓", [self returnValue:@"temperatureLow"]];

    current.text = [NSString stringWithFormat:@"Thực tế ~ %@°", [self returnValue:@"apparentTemperature"]];
    
    state.image = [UIImage imageNamed:[[currently getValueFromKey: @"icon"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
        
    dataSource = [@[] mutableCopy];

    titles = [@[] mutableCopy];

   _chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
       
    
    _chartView.xAxis.valueFormatter = [[DateValueFormatter alloc] init];

       _chartView.leftAxis.enabled = NO;
       
       
       _chartView.delegate = self;
       
       _chartView.chartDescription.enabled = NO;
       
       _chartView.dragEnabled = YES;
       [_chartView setScaleEnabled:NO];
       _chartView.pinchZoomEnabled = YES;
       _chartView.drawGridBackgroundEnabled = NO;

       // x-axis limit line
       ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
       llXAxis.lineWidth = 4.0;
       llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
       llXAxis.labelPosition = ChartLimitLabelPositionBottomRight;
       llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
           
       _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
       _chartView.xAxis.gridLineDashPhase = 0.f;
       
       ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:150.0 label:@"Upper Limit"];
       ll1.lineWidth = 4.0;
       ll1.lineDashLengths = @[@5.f, @5.f];
       ll1.labelPosition = ChartLimitLabelPositionTopRight;
       ll1.valueFont = [UIFont systemFontOfSize:10.0];
       
       ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@"Lower Limit"];
       ll2.lineWidth = 4.0;
       ll2.lineDashLengths = @[@5.f, @5.f];
       ll2.labelPosition = ChartLimitLabelPositionBottomRight;
       ll2.valueFont = [UIFont systemFontOfSize:10.0];
       
       ChartYAxis *leftAxis = _chartView.leftAxis;
       [leftAxis removeAllLimitLines];
       [leftAxis addLimitLine:ll1];
       [leftAxis addLimitLine:ll2];
       leftAxis.axisMaximum = 200.0;
       leftAxis.axisMinimum = -50.0;
       leftAxis.gridLineDashLengths = @[@5.f, @5.f];
       leftAxis.drawZeroLineEnabled = NO;
       leftAxis.drawLimitLinesBehindDataEnabled = YES;
       
       _chartView.rightAxis.enabled = NO;
       
       self.chartView.xAxis.drawGridLinesEnabled = NO;
       self.chartView.leftAxis.drawLabelsEnabled = NO;
       self.chartView.legend.enabled = NO;
       
       [_chartView animateWithXAxisDuration:2.5];
    
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

        NSLog(@"---->%@", [self returnValueH:data[@"hourly"][i]]);
        
        double val = [[self returnValueH:data[@"hourly"][i]] doubleValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:now y:val icon: [UIImage imageNamed:@"trans"]]];
        
//        double val = [[[data[@"hourly"][i][@"time"] componentsSeparatedByString:@" "] firstObject] doubleValue];
//        [values addObject:[[ChartDataEntry alloc] initWithX:val y:[[self returnValue:data[@"hourly"][i][@"temperature"]] doubleValue] icon: [UIImage imageNamed:@"trans"]]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        [set1 replaceEntries: values];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:values label:@""];
        
        set1.highlightColor = [UIColor clearColor];
        set1.drawIconsEnabled = NO;
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#78A6E5"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FFFFFF"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
        
         for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = NO;
            set.mode = LineChartModeCubicBezier;
        }
            
        [_chartView setNeedsDisplay];
    }
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

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
