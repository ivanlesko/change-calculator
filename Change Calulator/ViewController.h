//
//  ViewController.h
//  Change Calulator
//
//  Created by Ivan on 10/12/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BoxView.h"
#import <Parse/Parse.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *barsView;

@property (nonatomic, strong) IBOutlet UIView *amountView;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel *dollarLabel;
@property (nonatomic, strong) IBOutlet UITextField *amountField;

@property (nonatomic, strong) IBOutlet UIButton *clearButton;
@property (nonatomic, strong) IBOutlet UIButton *calcButton;

- (IBAction)calculate:(id)sender;
- (IBAction)clear:(id)sender;

// Button Properties
@property (nonatomic, assign) CGPoint clearPosition;
@property (nonatomic, assign) CGPoint clearHiddenPosition;
@property (nonatomic, assign) BOOL clearButtonInReadyPosition;

@property (nonatomic, assign) CGPoint calcPosition;
@property (nonatomic, assign) CGPoint calcHiddenPosition;
@property (nonatomic, assign) BOOL calcButtonInReadyPosition;

@property (nonatomic, assign) CGFloat buttonAnimSpeed;

// Currency Properties
@property (nonatomic, strong) NSDecimalNumber *totalAmount;
@property (nonatomic, assign) int coinsCount;

@property (nonatomic, strong) NSDecimalNumber *quarterCount;
@property (nonatomic, strong) NSDecimalNumber *quarterAmount;

@property (nonatomic, strong) NSDecimalNumber *dimeCount;
@property (nonatomic, strong) NSDecimalNumber *dimeAmount;

@property (nonatomic, strong) NSDecimalNumber *nickelCount;
@property (nonatomic, strong) NSDecimalNumber *nickelAmount;

@property (nonatomic, strong) NSDecimalNumber *pennyCount;
@property (nonatomic, strong) NSDecimalNumber *pennyAmount;

@property (nonatomic, strong) NSMutableArray *boxes;
@property (nonatomic, assign) CGFloat boxWidth;

@property (nonatomic, strong) BoxView *quarterBox;
@property (nonatomic, strong) BoxView *dimeBox;
@property (nonatomic, strong) BoxView *nickelBox;
@property (nonatomic, strong) BoxView *pennyBox;

@end






