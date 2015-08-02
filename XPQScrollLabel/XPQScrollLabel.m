//
//  XPQScrollLabel.m
//  XPQScrollLabel
//
//  Created by 谢攀琪 on 15/7/18.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#define IOS_VER ([[[UIDevice currentDevice] systemVersion] floatValue])

#import "XPQScrollLabel.h"

@interface XPQScrollLabel () {
    CFTimeInterval _pausedTime;
    BOOL _isRight;
    CGRect _leftRect;
    CGRect _rightRect;
}
@property (nonatomic, weak) UILabel *label;
@end

@implementation XPQScrollLabel

#pragma mark - ScrollLabel属性
-(void)setBounds:(CGRect)bounds {
    super.bounds = bounds;
    if (_label) {
        [self calcLabelFrame];
    }
}

-(void)setTime:(CGFloat)time {
    _time = time;
    if (time <= 0.01) {
        self.type = XPQScrollLabelTypeBan;
    }
}

-(void)setType:(XPQScrollLabelType)type {
    _type = type;
    switch (type) {
        case XPQScrollLabelTypeRepeat:
            
            break;
            
        case XPQScrollLabelTypeClick:
            
            break;
            
        case XPQScrollLabelTypeBan:
            
            break;
            
        default:
            _type = XPQScrollLabelTypeRepeat;
            
            break;
    }
}

#pragma mark - 构造函数
-(instancetype)init {
    self = [super init];
    if (self) {
        [self configLabel];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configLabel];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configLabel];
    }
    return self;
}

-(void)configLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    _label = label;
    [self addSubview:label];
    self.clipsToBounds = YES;
}

#pragma mark -辅助函数
/*
 *  @brief  根据text和font来修改_label的大小和y坐标，让label垂直居中
 */
-(void)calcLabelFrame {
    [self.label sizeToFit];
    _leftRect = CGRectMake(0, (self.frame.size.height - self.label.frame.size.height) / 2, self.label.frame.size.width + 10, self.label.frame.size.height);
    _rightRect = CGRectOffset(_leftRect, self.frame.size.width - _leftRect.size.width, 0);
    self.label.frame = _leftRect;
}

#pragma mark - 动画
/**
 *  @brief  启动动画
 */
-(void)startAnimation {
    if (self.time < 0.1) {
        return;
    }
    
    [UIView beginAnimations:@"scroll" context:NULL];
    [UIView setAnimationDuration:self.time];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    self.label.frame = _isRight ? _rightRect : _leftRect;
    [UIView commitAnimations];
}

/**
 *  @brief  停止动画
 */
-(void)stopAnimation {
    [self.label.layer removeAllAnimations];
}

/**
 *  @brief  暂停动画
 */
-(void)suspendAnimation {
    _pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = _pausedTime;
}

/**
 *  @brief  继续动画
 */
-(void)continueAnimation {
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - _pausedTime;
    self.layer.beginTime = timeSincePause;
}

-(void)animationDidStop {
    _isRight = !_isRight;
    [self startAnimation];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self suspendAnimation];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self continueAnimation];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGFloat x1 = [touch locationInView:self].x;
    CGFloat x2 = [touch previousLocationInView:self].x;
    _pausedTime += (_isRight ? x2 - x1 : x1 - x2) / (self.label.bounds.size.width - self.bounds.size.width);
    self.layer.timeOffset = _pausedTime;
}
@end

/**
 *  @brief  为了方便把UILabel替换成XPQScrollLabel，把UILabel的属性都在这写一下把值传给_label。
 */
@implementation XPQScrollLabel (UILabelProperty)
#pragma mark - UILabel属性设置
// 这些属性直接传给UILabel
-(NSString *)text {
    return _label.text;
}

-(void)setText:(NSString *)text {
    _label.text = text;
    [self calcLabelFrame];
}

-(UIFont *)font {
    return _label.font;
}

-(void)setFont:(UIFont *)font {
    _label.font = font;
    [self calcLabelFrame];
}

-(UIColor *)textColor {
    return _label.textColor;
}

-(void)setTextColor:(UIColor *)textColor {
    _label.textColor = textColor;
}

-(UIColor *)shadowColor {
    return _label.shadowColor;
}

-(void)setShadowColor:(UIColor *)shadowColor {
    _label.shadowColor = shadowColor;
}

-(CGSize)shadowOffset {
    return _label.shadowOffset;
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    _label.shadowOffset = shadowOffset;
}

-(NSTextAlignment)textAlignment {
    return _label.textAlignment;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment {
    _label.textAlignment = textAlignment;
}

-(NSLineBreakMode)lineBreakMode {
    return _label.lineBreakMode;
}

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _label.lineBreakMode = lineBreakMode;
}

-(NSAttributedString *)attributedText {
    return _label.attributedText;
}

-(void)setAttributedText:(NSAttributedString *)attributedText {
    _label.attributedText = attributedText;
}

-(UIColor *)highlightedTextColor {
    return _label.highlightedTextColor;
}

-(void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    _label.highlightedTextColor = highlightedTextColor;
}

-(BOOL)isHighlighted {
    return _label.isHighlighted;
}

-(void)setHighlighted:(BOOL)highlighted {
    _label.highlighted = highlighted;
}

-(BOOL)isEnabled {
    return _label.isEnabled;
}

-(void)setEnabled:(BOOL)enabled {
    _label.enabled = enabled;
}

-(NSInteger)numberOfLines {
    return _label.numberOfLines;
}

-(void)setNumberOfLines:(NSInteger)numberOfLines {
    _label.numberOfLines = numberOfLines;
}

-(BOOL)adjustsFontSizeToFitWidth {
    return _label.adjustsFontSizeToFitWidth;
}

-(void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    _label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

-(UIBaselineAdjustment)baselineAdjustment {
    return _label.baselineAdjustment;
}

-(void)setBaselineAdjustment:(UIBaselineAdjustment)baselineAdjustment {
    _label.baselineAdjustment = baselineAdjustment;
}

-(CGFloat)minimumScaleFactor {
    return _label.minimumScaleFactor;
}

-(void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor {
    _label.minimumScaleFactor = minimumScaleFactor;
}

-(CGFloat)preferredMaxLayoutWidth {
    return _label.preferredMaxLayoutWidth;
}

-(void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _label.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
}
@end
