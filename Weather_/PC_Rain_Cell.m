//
//  PC_Rain_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/17/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Rain_Cell.h"

@interface PC_Rain_Cell ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    IBOutlet UIButton * daily, * weekLy;
    
    IBOutlet UICollectionView * collectionView;
    
    BOOL day;
}

@end

@implementation PC_Rain_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [collectionView withCell:@"Rainy_Cell"];
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Rainy_Cell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 205);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
