//
//  BoxView.m
//  Change Calulator
//
//  Created by Ivan on 10/14/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "BoxView.h"

@implementation BoxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coinType = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.30, frame.size.width, 30)];
        _coinType.backgroundColor   = [UIColor clearColor];
        _coinType.textColor         = [UIColor whiteColor];
        _coinType.textAlignment     = NSTextAlignmentCenter;
        _coinType.text              = @"Type";
        
        _coinAmount = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.5, frame.size.width, 50)];
        _coinAmount.backgroundColor   = [UIColor clearColor];
        _coinAmount.textColor         = [UIColor whiteColor];
        _coinAmount.textAlignment     = NSTextAlignmentCenter;
        _coinAmount.text              = @"Count";
        _coinAmount.font              = [UIFont systemFontOfSize:38];
        
        _dollarAmount = [[UILabel alloc] initWithFrame:CGRectMake(0, _coinAmount.frame.origin.y + _coinAmount.frame.size.height, frame.size.width, 30)];
        _dollarAmount.backgroundColor   = [UIColor clearColor];
        _dollarAmount.textColor         = [UIColor whiteColor];
        _dollarAmount.textAlignment     = NSTextAlignmentCenter;
        _dollarAmount.text              = @"$0.00";
        
        [self addSubview:_coinType];
        [self addSubview:_coinAmount];
        [self addSubview:_dollarAmount];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
