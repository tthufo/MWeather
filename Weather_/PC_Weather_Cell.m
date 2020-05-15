//
//  PC_Weather_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Weather_Cell.h"

#import "DateValueFormatter.h"

@import Charts;

#include <math.h>

@interface PC_Weather_Cell ()<ChartViewDelegate>
{
    NSMutableArray * dataSource, * titles;
    
    IBOutlet UILabel * date, * temprature, * unit, * up, * down, * current;
    
    IBOutlet UIImageView * state;
}

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@end

@implementation PC_Weather_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];
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

    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.noDataText = @"";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = YES;
    _chartView.pinchZoomEnabled = YES;
    
    _chartView.backgroundColor = [UIColor colorWithWhite:204/255.f alpha:0.f];
    
    ChartLegend *l = _chartView.legend;
    l.form = ChartLegendFormLine;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.textColor = UIColor.blackColor;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.labelTextColor = UIColor.blackColor;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.drawAxisLineEnabled = YES;
    
    xAxis.valueFormatter = [[DateValueFormatter alloc] init];
    xAxis.labelPosition = XAxisLabelPositionBottom;
        
    xAxis.granularity = 3600.0;


    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelTextColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    leftAxis.axisMaximum = 900.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.granularityEnabled = YES;
    leftAxis.granularity = 100;
    
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.labelTextColor = UIColor.redColor;
    rightAxis.axisMaximum = 900.0;
    rightAxis.axisMinimum = 0.0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.granularityEnabled = NO;
    
    [_chartView animateWithXAxisDuration:2.5];
}

- (NSString*)returnValue:(NSString*)key {
            
    NSDictionary * currently = data[@"currently"];

    double tempo = [[self getValue:@"deg"] isEqualToString:@"0"] ? [[currently getValueFromKey:key] doubleValue] : ([[currently getValueFromKey:key] doubleValue] * 9/5) + 32;

    NSString * value = [NSString stringWithFormat:@"%.f", ceil(tempo)];
    
    return value;
}

- (UIColor *)getRandomColor
{
    srand48(arc4random());
    
    float red = 0.0;
    while (red < 0.1 || red > 0.84) {
        red = drand48();
    }
    
    float green = 0.0;
    while (green < 0.1 || green > 0.84) {
        green = drand48();
    }
    
    float blue = 0.0;
    while (blue < 0.1 || blue > 0.84) {
        blue = drand48();
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (NSDate*)date:(NSString*)dateString
{
    return [[[dateString componentsSeparatedByString:@"T"] firstObject] dateWithFormat:@"yyyy-MM-dd"];
}

- (void)setData
{
    _chartView.data = nil;
    
    NSMutableArray * dataList = [NSMutableArray new];
    
    for(int o = 0; o < dataSource.count; o++)
    {
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        
        
        for(int i = 0; i < ((NSArray*)dataSource[o][@"Data"]).count; i++)
        {
//            NSLog(@"%@", dataSource[o][@"Data"][i][@"NgayApDung"]);

            NSTimeInterval now = [[self date:dataSource[o][@"Data"][i][@"NgayApDung"]] timeIntervalSince1970];

            [arr addObject:[[ChartDataEntry alloc] initWithX:now y:[((NSArray*)dataSource[o][@"Data"])[i][@"Gia"] intValue]]];
        }
        
        LineChartDataSet *set1 = nil;

//        if (_chartView.data.dataSetCount > 0)
//        {
//            set1 = (LineChartDataSet *)_chartView.data.dataSets[o];
//
//            set1.values = arr;
//
//            [_chartView.data notifyDataChanged];
//
//            [_chartView notifyDataSetChanged];
//        }
//        else
        {
            set1 = [[LineChartDataSet alloc] initWithValues:arr label:dataSource[o][@"Ten"]];
            set1.axisDependency = AxisDependencyLeft;
            [set1 setColor:[self getRandomColor]];//[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
            [set1 setCircleColor:UIColor.darkGrayColor];
            set1.lineWidth = 2.0;
            set1.circleRadius = 4.0;
            set1.fillAlpha = 65/255.0;
            set1.fillColor = [self getRandomColor];//[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
            set1.highlightColor = [self getRandomColor];//[UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
            set1.drawCircleHoleEnabled = NO;
        }
        
        [dataList addObject:set1];
    }
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataList];
    [data setValueTextColor:UIColor.blackColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    [_chartView.data notifyDataChanged];
    [_chartView notifyDataSetChanged];
    
    _chartView.data = data;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
