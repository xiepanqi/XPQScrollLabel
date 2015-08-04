//
//  XPQScrollLabel.m
//  XPQScrollLabel
//
//  Created by 谢攀琪 on 15/7/18.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#define IOS_VER ([[[UIDevice currentDevice] systemVersion] floatValue])

#import "XPQScrollLabel.h"

#define kAnimationKey       @"scrollAnimation"

@interface XPQScrollLabel () {
    /**
     *  @brief  滚动动画暂停时时间
     */
    CFTimeInterval _pausedTime;
    /**
     *  @brief  YES-在向右滚动，NO-在向左滚动
     */
    BOOL _isRight;
}
@property (nonatomic, weak) UILabel *label;
/**
 *  @brief  左滚动画
 */
@property (nonatomic) CABasicAnimation *leftScrollAnimation;
/**
 *  @brief  右滚动画
 */
@property (nonatomic) CABasicAnimation *rightScrollAnimation;
@end

@implementation XPQScrollLabel

#pragma mark - ScrollLabel属性
-(void)setBounds:(CGRect)bounds {
    super.bounds = bounds;
    if (_label) {
        [self calcLabelFrame];
        [self startAnimation];
    }
}

-(void)setTime:(CGFloat)time {
    _time = time;
    if (time <= 0.01) {
        self.type = XPQScrollLabelTypeBan;
    }
    else {
        self.leftScrollAnimation.duration = time;
        self.rightScrollAnimation.duration = time;
        [self startAnimation];
    }
}

-(void)setType:(XPQScrollLabelType)type {
    _type = type;
    switch (type) {
        case XPQScrollLabelTypeRepeat:
            [self startAnimation];
            break;
            
        case XPQScrollLabelTypeClick:
            
            break;
            
        case XPQScrollLabelTypeBan:
            [self stopAnimation];
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
    self.label.frame = CGRectMake(0, (self.frame.size.height - self.label.frame.size.height) / 2, self.label.frame.size.width + 10, self.label.frame.size.height);
    self.leftScrollAnimation = [self creadAnimation:YES];
    self.rightScrollAnimation = [self creadAnimation:NO];
}

#pragma mark - 动画
/**
 *  @brief  创建左右滚动动画
 *  @param isRight 是向右滚动不
 *  @return 创建好的滚动动画
 */
-(CABasicAnimation *)creadAnimation:(BOOL)isRight {
    // 靠最左边时的中心点
    NSValue *leftValue = [NSValue valueWithCGPoint:self.label.center];
    // 靠最右边时的中心店
    NSValue *rightValue = [NSValue valueWithCGPoint:CGPointMake(self.label.center.x + (self.frame.size.width - self.label.frame.size.width), self.label.center.y)];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = isRight ? leftValue : rightValue;
    animation.toValue = isRight ? rightValue : leftValue;
    animation.duration = self.time;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    return animation;
}

/**
 *  @brief  启动动画
 */
-(void)startAnimation {
    if (self.time < 0.1
        || self.type == XPQScrollLabelTypeBan
        || self.leftScrollAnimation == nil
        || self.rightScrollAnimation == nil) {
        return;
    }
    
    [self.label.layer addAnimation:_isRight ? self.rightScrollAnimation : self.leftScrollAnimation forKey:kAnimationKey];
}

/**
 *  @brief  停止动画
 */
-(void)stopAnimation {
    [self.label.layer removeAnimationForKey:kAnimationKey];
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

/**
 *  @brief  动画结束时触发，在这里再次启动动画，让动画一直循环下去
 */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        _isRight = !_isRight;
        if (self.type == XPQScrollLabelTypeRepeat) {
            [self startAnimation];
        }
        else if (self.type == XPQScrollLabelTypeClick) {
            if (_isRight) {
                [self startAnimation];
            }
        }
    }
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
    _pausedTime += (_isRight ? x1 - x2 : x2 - x1) / (self.label.bounds.size.width - self.bounds.size.width);
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

#pragma mark -UILabel函数
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    return [_label textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
}
- (void)drawTextInRect:(CGRect)rect {
    [_label drawTextInRect:rect];
}
@end
