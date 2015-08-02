//
//  XPQScrollLabel.h
//  XPQScrollLabel
//
//  Created by 谢攀琪 on 15/7/18.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XPQScrollLabelTypeRepeat,   /// 重复来回滚动
    XPQScrollLabelTypeClick,        /// 点击一下才滚动一个来回
    XPQScrollLabelTypeBan,          /// 不滚动
} XPQScrollLabelType;

@interface XPQScrollLabel : UIView
#pragma mark - UILabel属性
@property (nonatomic) IBInspectable NSString *text;
@property (nonatomic) IBInspectable UIFont *font;
@property (nonatomic) IBInspectable UIColor *textColor;
@property (nonatomic) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) IBInspectable NSTextAlignment textAlignment;
@property (nonatomic) NSLineBreakMode lineBreakMode;
@property (nonatomic) NSAttributedString *attributedText NS_AVAILABLE_IOS(6_0);
@property (nonatomic) UIColor *highlightedTextColor;
@property (nonatomic,getter=isHighlighted) BOOL highlighted;
@property (nonatomic,getter=isEnabled) BOOL enabled;
@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) BOOL adjustsFontSizeToFitWidth;
@property (nonatomic) UIBaselineAdjustment baselineAdjustment;
@property (nonatomic) CGFloat minimumScaleFactor NS_AVAILABLE_IOS(6_0);
@property (nonatomic) CGFloat preferredMaxLayoutWidth NS_AVAILABLE_IOS(6_0);

#pragma mark - XPQScrollLabel属性
@property (nonatomic) IBInspectable BOOL gestureEnable;         /// 是否开始手势移动文字
@property (nonatomic) IBInspectable XPQScrollLabelType type;    /// 滚动类型
@property (nonatomic) IBInspectable CGFloat time;               /// 滚动一来回时间，单位秒,小于等于0时类型修改为XPQScrollLabelTypeBan

-(void)startAnimation;
-(void)stopAnimation;
@end
