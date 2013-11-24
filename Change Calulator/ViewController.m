//
//  ViewController.m
//  Change Calulator
//
//  Created by Ivan on 10/12/13.
//  Copyright (c) 2013 Ivan. All rights reserved.
//

#import "ViewController.h"
#import "BoxView.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

#define QUARTER 0.25
#define DIME    0.1
#define NICKEL  0.05
#define PENNY   0.01

#define BTN_ANIM_SPEED 4.0

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupViews];
}

#pragma mark - - Setup Views

- (void)setupViews
{
    [self setupAmountView];
    [self setupAmountField];
    [self setupBarsView];
    [self setupButtons];
    [self setupCoinBars];
}

- (void)setupAmountView
{
    _backgroundImageView.image = [UIImage imageNamed:@"ChangeCalc_BG_02.jpg"];
}

- (void)setupAmountField
{
    UIGestureRecognizer *activateAmountField = [[UITapGestureRecognizer alloc] initWithTarget:_amountField action:@selector(becomeFirstResponder)];
    [_amountView addGestureRecognizer:activateAmountField];
    
    _amountField.delegate = self;
    _amountField.autocorrectionType = UITextAutocapitalizationTypeNone;
    _amountField.keyboardType       = UIKeyboardTypeNumberPad;
}

- (void)setupBarsView
{
    UITapGestureRecognizer *removeKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [_barsView addGestureRecognizer:removeKeyboardTap];
}

- (void)setupButtons
{
    // Clear Button
    _clearPosition = _clearButton.layer.position;
    _clearHiddenPosition = CGPointMake(_clearPosition.x,
                                       _clearPosition.y + _clearButton.layer.bounds.size.height);
    
    _clearButton.layer.position = _clearHiddenPosition;
    _clearButton.layer.opacity = 1;
    _clearButton.userInteractionEnabled = NO;
    _clearButtonInReadyPosition = NO;
    
    // Calculate Buttons
    _calcPosition = _calcButton.layer.position;
    _calcHiddenPosition = CGPointMake(_calcPosition.x,
                                      _calcPosition.y + _calcButton.layer.bounds.size.height);
    
    _calcButton.layer.position = _calcHiddenPosition;
    _calcButton.layer.opacity  = 1;
    _calcButton.userInteractionEnabled = NO;
    _calcButtonInReadyPosition = NO;
    
    [_calcButton removeFromSuperview];
    [_clearButton removeFromSuperview];
    
    // Set the animation Speed
    _buttonAnimSpeed = 4.0;
}

- (void)setupCoinBars
{
    _quarterBox = [[BoxView alloc] init];
    _quarterBox.coinType.text = @"¢25";
    _quarterBox.coinAmount.text = [_quarterCount stringValue];
    _quarterBox.dollarAmount.text = [_quarterAmount stringValue];
    
    _dimeBox = [[BoxView alloc] init];
    _dimeBox.coinType.text = @"¢10";
    _dimeBox.coinAmount.text = [_dimeCount stringValue];
    _dimeBox.dollarAmount.text = [_dimeAmount stringValue];
    
    _nickelBox = [[BoxView alloc] init];
    _nickelBox.coinType.text = @"¢5";
    _nickelBox.coinAmount.text = [_nickelCount stringValue];
    _nickelBox.dollarAmount.text = [_nickelAmount stringValue];
    
    _pennyBox = [[BoxView alloc] init];
    _pennyBox.coinType.text = @"¢1";
    _pennyBox.coinAmount.text = [_pennyCount stringValue];
    _pennyBox.dollarAmount.text = [_pennyAmount stringValue];
    
    NSLog(@"totalAmount = %.2f", _totalAmount.floatValue);
}

- (void)dismissKeyboard
{
    [_amountField resignFirstResponder];
}

#pragma mark - - Button Animations
- (void)showCalcButton
{
    [self.view addSubview:_calcButton];
    
    CABasicAnimation *show = [CABasicAnimation animationWithKeyPath:@"position"];
    show.fromValue = [NSValue valueWithCGPoint:_calcHiddenPosition];
    show.toValue   = [NSValue valueWithCGPoint:_calcPosition];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithFloat:0.0];
    opacity.toValue   = [NSNumber numberWithFloat:1.0];
    
    NSArray *anims = [NSArray arrayWithObjects:show, opacity, nil];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = anims;
    animGroup.duration = 1;
    animGroup.speed = BTN_ANIM_SPEED;
    animGroup.removedOnCompletion = YES;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    _calcButton.layer.position = _calcPosition;
    _calcButton.layer.opacity  = 1.0;
    _calcButton.userInteractionEnabled = YES;
    _calcButtonInReadyPosition = YES;
    
    [_calcButton.layer addAnimation:animGroup forKey:nil];
}

- (void)hideCalcButton
{
    CABasicAnimation *hide = [CABasicAnimation animationWithKeyPath:@"position"];
    hide.fromValue = [NSValue valueWithCGPoint:_calcPosition];
    hide.toValue   = [NSValue valueWithCGPoint:_calcHiddenPosition];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithFloat:1.0];
    opacity.toValue   = [NSNumber numberWithFloat:0.0];
    
    NSArray *anims = [NSArray arrayWithObjects:hide, opacity, nil];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = anims;
    animGroup.duration   = 1;
    animGroup.speed      = BTN_ANIM_SPEED;
    animGroup.removedOnCompletion = YES;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    _calcButton.layer.position = _calcHiddenPosition;
    _calcButton.layer.opacity  = 0;
    _calcButton.userInteractionEnabled = NO;
    _calcButtonInReadyPosition = NO;
    
    [_calcButton.layer addAnimation:animGroup forKey:nil];
}

- (void)showClearButton
{
    [self.view addSubview:_clearButton];
    
    CABasicAnimation *show = [CABasicAnimation animationWithKeyPath:@"position"];
    show.fromValue = [NSValue valueWithCGPoint:_clearHiddenPosition];
    show.toValue   = [NSValue valueWithCGPoint:_clearPosition];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithFloat:0.0];
    opacity.toValue   = [NSNumber numberWithFloat:1.0];

    NSArray *anims = [NSArray arrayWithObjects:show, opacity, nil];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = anims;
    animGroup.duration   = 1;
    animGroup.speed      = BTN_ANIM_SPEED;
    animGroup.fillMode   = kCAFillModeForwards;
    animGroup.removedOnCompletion = YES;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    _clearButton.layer.position = _clearPosition;
    _clearButton.layer.opacity  = 1.0;
    _clearButton.userInteractionEnabled = YES;
    _clearButtonInReadyPosition = YES;
    
    [_clearButton.layer addAnimation:animGroup forKey:nil];
}

- (void)hideClearButton
{
    CABasicAnimation *hide = [CABasicAnimation animationWithKeyPath:@"position"];
    hide.fromValue = [NSValue valueWithCGPoint:_clearPosition];
    hide.toValue   = [NSValue valueWithCGPoint:_clearHiddenPosition];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithFloat:1.0];
    opacity.toValue   = [NSNumber numberWithFloat:0.0];
    
    NSArray *anims = [NSArray arrayWithObjects:hide, opacity, nil];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = anims;
    animGroup.duration   = 1;
    animGroup.speed      = BTN_ANIM_SPEED;
    animGroup.removedOnCompletion = YES;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    _clearButton.layer.position = _clearHiddenPosition;
    _clearButton.layer.opacity  = 0;
    _clearButton.userInteractionEnabled = NO;
    _clearButtonInReadyPosition = NO;
    
    [_clearButton.layer addAnimation:animGroup forKey:nil];
}

#pragma mark - - IB Actions
- (IBAction)calculate:(id)sender
{
    [self dismissKeyboard];
    [self hideCalcButton];
    
    [self drawBars];
    
    if (!_clearButtonInReadyPosition){
        [self showClearButton];
    }
}

- (IBAction)clear:(id)sender
{
    [self hideClearButton];
    [self removeBars];
    
    [self textFieldShouldClear:_amountField];
}

#pragma mark - - Coin Math
- (void) coinMath
{
    _coinsCount = 0;
    
    NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                               scale:0
                                                                                    raiseOnExactness:NO
                                                                                     raiseOnOverflow:NO
                                                                                    raiseOnUnderflow:NO
                                                                                 raiseOnDivideByZero:YES];
    
    NSDecimalNumber *quarterRemainder, *dimeRemainder, *nickelRemainder;
    NSDecimalNumber *quarter, *dime, *nickel, *penny;
    
    quarter = [NSDecimalNumber decimalNumberWithString:@".25"];
    dime    = [NSDecimalNumber decimalNumberWithString:@".10"];
    nickel  = [NSDecimalNumber decimalNumberWithString:@".05"];
    penny   = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    
    _quarterCount     = [_totalAmount decimalNumberByDividingBy:quarter withBehavior:roundDown];
    _quarterAmount    = [_quarterCount decimalNumberByMultiplyingBy:quarter];
    quarterRemainder = [_totalAmount decimalNumberBySubtracting:_quarterAmount];
    if (_quarterCount.doubleValue != 0) _coinsCount++;
    
    _dimeCount = [quarterRemainder decimalNumberByDividingBy:dime withBehavior:roundDown];
    _dimeAmount = [_dimeCount decimalNumberByMultiplyingBy:dime];
    dimeRemainder = [quarterRemainder decimalNumberBySubtracting:_dimeAmount];
    if (_dimeCount.doubleValue != 0) _coinsCount++;
    
    _nickelCount = [dimeRemainder decimalNumberByDividingBy:nickel withBehavior:roundDown];
    _nickelAmount = [_nickelCount decimalNumberByMultiplyingBy:nickel];
    nickelRemainder = [dimeRemainder decimalNumberBySubtracting:_nickelAmount];
    if (_nickelCount.doubleValue != 0) _coinsCount++;
    
    _pennyCount = [nickelRemainder decimalNumberByDividingBy:penny withBehavior:roundDown];
    _pennyAmount = [_pennyCount decimalNumberByMultiplyingBy:penny];
    if (_pennyCount.doubleValue != 0) _coinsCount++;
}

#pragma mark - - Animations

- (void)drawBars
{
    [self coinMath];
    
    _boxWidth = _barsView.bounds.size.width / _coinsCount;
    
    CGFloat xOrigin = 0;
    
    CGFloat hue = 75;
    CGFloat sat = 75;
    CGFloat lum = 75.0;

    PFObject *amounts = [PFObject objectWithClassName:@"Amounts"];
    
    if ([_quarterCount intValue] != 0) {
        _quarterBox = [[BoxView alloc] initWithFrame:CGRectMake(xOrigin, self.view.bounds.origin.y, _boxWidth, self.view.bounds.size.height)];
        _quarterBox.coinType.text = @"¢25";
        _quarterBox.coinAmount.text = [_quarterCount stringValue];
        _quarterBox.dollarAmount.text = [NSString stringWithFormat:@"$%@", [_quarterAmount stringValue]];
        _quarterBox.backgroundColor = [UIColor colorWithHue:hue / 360.0
                                                 saturation:sat / 100.0
                                                 brightness:lum / 100.0
                                                      alpha:1];
        
        [_quarterBox.layer addAnimation:[self positionSlideIntoViewAnim:_quarterBox.layer andBoxWidth:_boxWidth] forKey:nil];
        [_barsView addSubview:_quarterBox];
        
        xOrigin += _boxWidth;
        lum -= 15;
        
        [amounts setObject:[NSNumber numberWithInt:[_quarterCount intValue]] forKey:@"QuarterCount"];
        [amounts setObject:[NSNumber numberWithFloat:[_quarterAmount floatValue]] forKey:@"QuarterAmount"];
    }
    
    if ([_dimeCount intValue] != 0) {
        _dimeBox = [[BoxView alloc] initWithFrame:CGRectMake(xOrigin, self.view.bounds.origin.y, _boxWidth, self.view.bounds.size.height)];
        _dimeBox.coinType.text = @"¢10";
        _dimeBox.coinAmount.text = [_dimeCount stringValue];
        _dimeBox.dollarAmount.text = [NSString stringWithFormat:@"$%@", [_dimeAmount stringValue]];
        _dimeBox.backgroundColor = [UIColor colorWithHue:hue / 360.0
                                              saturation:sat / 100.0
                                              brightness:lum / 100.0
                                                   alpha:1];
        [_dimeBox.layer addAnimation:[self positionSlideIntoViewAnim:_dimeBox.layer andBoxWidth:_boxWidth] forKey:nil];
        [_barsView addSubview:_dimeBox];
        
        xOrigin += _boxWidth;
        lum -= 15;
        
        [amounts setObject:[NSNumber numberWithInt:[_dimeCount intValue]] forKey:@"DimeCount"];
        [amounts setObject:[NSNumber numberWithFloat:[_dimeAmount floatValue]] forKey:@"DimeAmount"];
    }
    
    if ([_nickelCount intValue] != 0) {
        _nickelBox = [[BoxView alloc] initWithFrame:CGRectMake(xOrigin, self.view.bounds.origin.y, _boxWidth, self.view.bounds.size.height)];
        _nickelBox.coinType.text = @"¢5";
        _nickelBox.coinAmount.text = [_nickelCount stringValue];
        _nickelBox.dollarAmount.text = [NSString stringWithFormat:@"$%@", [_nickelAmount stringValue]];
        _nickelBox.backgroundColor = [UIColor colorWithHue:hue / 360.0
                                              saturation:sat / 100.0
                                              brightness:lum / 100.0
                                                   alpha:1];
        [_nickelBox.layer addAnimation:[self positionSlideIntoViewAnim:_nickelBox.layer andBoxWidth:_boxWidth] forKey:nil];
        [_barsView addSubview:_nickelBox];
        
        xOrigin += _boxWidth;
        lum -= 15;
        
        [amounts setObject:[NSNumber numberWithInt:[_nickelCount intValue]] forKey:@"NickelCount"];
        [amounts setObject:[NSNumber numberWithFloat:[_nickelAmount floatValue]] forKey:@"NickelAmount"];
    }
    
    if ([_pennyCount intValue] != 0) {
        _pennyBox = [[BoxView alloc] initWithFrame:CGRectMake(xOrigin, self.view.bounds.origin.y, _boxWidth, self.view.bounds.size.height)];
        _pennyBox.coinType.text = @"¢1";
        _pennyBox.coinAmount.text = [_pennyCount stringValue];
        _pennyBox.dollarAmount.text = [NSString stringWithFormat:@"$%@", [_pennyAmount stringValue]];
        _pennyBox.backgroundColor = [UIColor colorWithHue:hue / 360.0
                                                saturation:sat / 100.0
                                                brightness:lum / 100.0
                                                     alpha:1];
        [_pennyBox.layer addAnimation:[self positionSlideIntoViewAnim:_pennyBox.layer andBoxWidth:_boxWidth] forKey:nil];
        [_barsView addSubview:_pennyBox];
        
        xOrigin += _boxWidth;
        lum -= 15;
        
        [amounts setObject:[NSNumber numberWithInt:[_pennyCount intValue]] forKey:@"PennyCount"];
        [amounts setObject:[NSNumber numberWithFloat:[_pennyAmount floatValue]] forKey:@"PennyAmount"];
    }
    [amounts setObject:[NSNumber numberWithFloat:[_totalAmount floatValue]] forKey:@"TotalAmount"];
    
    [amounts saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"object uploaded");
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

- (CABasicAnimation *)positionSlideIntoViewAnim:(CALayer *)theLayer andBoxWidth:(CGFloat)theBoxWidth
{
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.fromValue = [NSValue valueWithCGPoint:CGPointMake(theLayer.position.x - theBoxWidth, theLayer.position.y)];
    position.toValue   = [NSValue valueWithCGPoint:theLayer.position];
    position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    position.speed = BTN_ANIM_SPEED;
    position.duration = 2;
    position.removedOnCompletion = YES;
    position.fillMode = kCAFillModeForwards;
    
    return position;
}

- (void)removeBars
{
    for (BoxView *box in _barsView.subviews) {
        CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
        position.fromValue = [NSValue valueWithCGPoint:box.layer.position];
        position.toValue   = [NSValue valueWithCGPoint:CGPointMake(box.layer.position.x, box.layer.position.y - box.layer.bounds.size.height)];
        position.duration  = 1;
        position.speed     = BTN_ANIM_SPEED;
        position.fillMode  = kCAFillModeForwards;
        position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        box.layer.position = CGPointMake(_barsView.layer.position.x, _barsView.layer.position.y - box.layer.bounds.size.height);
        [box.layer addAnimation:position forKey:nil];
        
        [box performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    }
}


#pragma mark - - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_calcButtonInReadyPosition != TRUE) {
        [self showCalcButton];
        _calcButtonInReadyPosition = YES;
    }
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    double number = [text intValue] * 0.01;
    textField.text = [NSString stringWithFormat:@"%.2lf", number];
    
    if ([textField.text floatValue] != 0) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _totalAmount = [NSDecimalNumber decimalNumberWithString:textField.text];
    }
    
    return NO;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"0.00";
    textField.clearButtonMode = UITextFieldViewModeNever;
    
    if (_calcButtonInReadyPosition == TRUE) {
        [self hideCalcButton];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text floatValue] > 0) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
