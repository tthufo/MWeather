//
//  PC_Weather_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Weather_Cell.h"

#import "DateValueFormatter.h"

@interface PC_Weather_Cell ()<ChartViewDelegate>
{
    NSMutableArray * dataSource, * titles;
}

@end

@implementation PC_Weather_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
