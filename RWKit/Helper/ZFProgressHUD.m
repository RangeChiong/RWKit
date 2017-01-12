//
//  ZFProgressHUD.m
//  Test0103
//
//  Created by RangerChiong on 17/1/4.
//  Copyright © 2017年 Ranger. All rights reserved.
//

#import "ZFProgressHUD.h"

#define ZFMainThreadAssert() NSAssert([NSThread isMainThread], @"ZFProgressHUD needs to be accessed on the main thread.");

static const CGFloat ZFDefaultLabelFontSize = 16.f;
static const CGFloat ZFDefaultDetailLabelFontSize = 12.f;
static const CGFloat ZFProgressHUDHeightWhenTopPosition = 64.f;
static const CGFloat ZFProgressHUDHeightWhenBottomPosition = 54.f;

@interface ZFProgressHUD () {
    BOOL _finished;
}

@property (nonatomic, strong) UIView *indicator;

@end

@implementation ZFProgressHUD

#pragma mark-  class methods

+ (instancetype)showOnView:(UIView *)view animated:(BOOL)animated {
    ZFProgressHUD *hud = [[self alloc] initWithView:view];
    [hud showAnimated:animated];
    return hud;
}

+ (BOOL)hideOnView:(UIView *)view animated:(BOOL)animated {
    ZFProgressHUD *hud = [self HUDOnView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:animated];
        return YES;
    }
    return NO;
}

+ (ZFProgressHUD *)HUDOnView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (ZFProgressHUD *)subview;
        }
    }
    return nil;
}

#pragma mark-  show hide

- (void)showAnimated:(BOOL)animated {
    ZFMainThreadAssert();
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(showAnimated:) withObject:@(animated) waitUntilDone:YES];
        return;
    }
    
    _finished = NO;
    [self showAnimated:animated done:nil];
}

- (void)showAnimated:(BOOL)animated done:(dispatch_block_t)block {

    [self.bezelView.layer removeAllAnimations];
    [self.backgroundView.layer removeAllAnimations];
    
    self.alpha = 1.f;
    
    if (animated) {
        [self animateIn:YES withType:self.animationType completion:^(BOOL finished) {
            !block ?: block();
        }];
    }
    else {
        self.bezelView.alpha = 1.f;
        self.backgroundView.alpha = 1.f;
        !block ?: block();
    }
}

- (void)hideAnimated:(BOOL)animated {
    ZFMainThreadAssert();
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(hideAnimated:) withObject:@(animated) waitUntilDone:YES];
        return;
    }
    
    _finished = YES;
    [self hideAnimated:animated delay:0.0 done:nil];
}

- (void)hideAnimated:(BOOL)animated done:(dispatch_block_t)block {
    ZFMainThreadAssert();
    if (![NSThread isMainThread]) {
        // 走没有回调的hide
        [self performSelectorOnMainThread:@selector(hideAnimated:) withObject:@(animated) waitUntilDone:YES];
        return;
    }
    
    _finished = YES;
    [self hideAnimated:animated delay:0.0 done:block];
}

- (void)hideAnimated:(BOOL)animated delay:(NSTimeInterval)ti done:(dispatch_block_t)block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ti * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (animated) {
            [self animateIn:NO withType:self.animationType completion:^(BOOL finished) {
                [self done];
                !block ?: block();
            }];
        }
        else {
            self.bezelView.alpha = 0.f;
            self.backgroundView.alpha = 1.f;
            [self done];
            !block ?: block();
        }
    });
}

- (void)animateIn:(BOOL)animatingIn withType:(ZFProgressHUDAnimation)type completion:(void(^)(BOOL finished))completion {

    if (self.position == ZFProgressHUDPosition_Top) {
        self.animationType = ZFProgressHUDAnimation_DropDown;
        [self animationForTopPosition:animatingIn completion:completion];
    }
    else {
        
        if (type == ZFProgressHUDAnimation_Zoom) {
            type = animatingIn ? ZFProgressHUDAnimation_ZoomIn : ZFProgressHUDAnimation_ZoomOut;
        }
        
        dispatch_block_t animations;
        UIView *bezelView = self.bezelView;
        CGAffineTransform small = CGAffineTransformMakeScale(0.5f, 0.5f);
        CGAffineTransform large = CGAffineTransformMakeScale(1.5f, 1.5f);
        if (animatingIn && bezelView.alpha == 0.f && type == ZFProgressHUDAnimation_ZoomIn) {
            bezelView.transform = small;
        }
        else if (animatingIn && bezelView.alpha == 0.f && type == ZFProgressHUDAnimation_ZoomOut) {
            bezelView.transform = large;
        }

        animations = ^{
            if (animatingIn) {
                bezelView.transform = CGAffineTransformIdentity;
            }
            else if (!animatingIn && type == ZFProgressHUDAnimation_ZoomIn) {
                bezelView.transform = large;
            }
            else if (!animatingIn && type == ZFProgressHUDAnimation_ZoomOut) {
                bezelView.transform = small;
            }

            bezelView.alpha = animatingIn ? 1.f : 0.f;
            self.backgroundView.alpha = animatingIn ? 1.f : 0.f;
        };
        
        [UIView animateWithDuration:0.3
                              delay:0.f
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:animations
                         completion:completion];
    }
}

- (void)done {
    
    if (_finished) {
        self.alpha = 0.0f;
        if (self.removeFromSuperViewOnHide) {
            [self removeFromSuperview];
        }
    }
}

#pragma mark-  animation

- (void)animationForTopPosition:(BOOL)animatingIn completion:(void(^)(BOOL finished))completion {
    UIView *bezelView = self.bezelView;

    bezelView.alpha = 1.f ;
    self.backgroundView.alpha = 1.f;
    
    if (animatingIn) {
        CGRect frame = bezelView.frame;
        frame.origin.y = -64;
        bezelView.frame = frame;
    }
    [UIView animateWithDuration:0.3
                          delay:0.f
         usingSpringWithDamping:0.8
          initialSpringVelocity:10.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect frame = bezelView.frame;
                         frame.origin.y = animatingIn ? 0 : -64;
                         bezelView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         if (!animatingIn) {
                             bezelView.alpha = 0.f ;
                             self.backgroundView.alpha = 0.f;
                         }
                         !completion ?: completion(finished);
                     }];
}

#pragma mark- Lifecycle

+ (instancetype)setupOnView:(UIView *)view {
    return [[self alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");

    if (!view)  {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    if (self = [self initWithFrame:view.bounds]) {
        [view addSubview:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.layer.allowsGroupOpacity = NO;
    
    [self setupViews];

    _margin = 20.f;
    self.position = ZFProgressHUDPosition_Center;
    self.mode = ZFProgressHUDMode_Indeterminate;
        
    [self registerNotifications];
}

- (void)setupViews {
    for (UIView *view in @[self.backgroundView, self.bezelView]) {
        [self addSubview:view];
    }

    for (UIView *view in @[self.titleLabel, self.detailLabel]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bezelView addSubview:view];
    }
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChangeStatusBarOrientationNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

#pragma mark-  layout

- (void)updateConstraints {
    UIView *bezel = self.bezelView;
    [bezel removeConstraints:bezel.constraints];
    
    NSMutableArray *subviews = [NSMutableArray arrayWithObjects:self.titleLabel, self.detailLabel, nil];
    if (self.indicator) [subviews insertObject:self.indicator atIndex:0];

    NSMutableArray *bezelConstraints = [NSMutableArray array];
    
    CGFloat padding = self.titleLabel.text.length || self.detailLabel.text.length ? self.margin/2 : self.margin;
    if (self.position == ZFProgressHUDPosition_Top) {
        CGFloat padding = 10;
        [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if ([subviews containsObject:self.indicator]) {
                if (idx == 0) {
                    [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeLeft multiplier:1.f constant:padding]];
                    [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];
                    [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[view]-(padding)-|" options:0 metrics:@{@"padding": @(padding)} views:NSDictionaryOfVariableBindings(view)]];
                }
                if (idx > 0) {
                    [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:subviews[0] attribute:NSLayoutAttributeRight multiplier:1.f constant:padding]];
                    [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[view]-(>=padding)-|" options:0 metrics:@{@"padding": @(padding)} views:NSDictionaryOfVariableBindings(view)]];
                }
            }
            else {
                [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeLeft multiplier:1.f constant:padding]];
                [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=padding)-[view]-(>=padding)-|" options:0 metrics:@{@"padding": @(padding)} views:NSDictionaryOfVariableBindings(view)]];
            }

            if (idx == subviews.count - 1) {
                UIView *lastView = subviews[idx - 1];
                [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[lastView][view]-(padding)-|" options:0 metrics:@{@"padding": @(padding)} views:NSDictionaryOfVariableBindings(lastView, view)]];
            }
        }];
    }
    else {
        [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            
            [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
            [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[view]-(>=margin)-|" options:0 metrics:@{@"margin": @(self.margin)} views:NSDictionaryOfVariableBindings(view)]];
            if (idx == 0) {
                [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeTop multiplier:1.f constant:padding]];
            }
            else if (idx == subviews.count - 1) {
                [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(margin)-|" options:0 metrics:@{@"margin": @(self.detailLabel.text ? padding : 0)} views:NSDictionaryOfVariableBindings(view)]];
                
            }
            if (idx > 0) {
                [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:subviews[idx - 1] attribute:NSLayoutAttributeBottom multiplier:1.f constant:padding]];
            }
        }];
    }

    [bezel addConstraints:bezelConstraints];
    
    [super updateConstraints];
}

#pragma mark-  bezel view constraints

- (NSArray *)bezelPositionConstraints:(ZFProgressHUDPosition)position {
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.bezelView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];

    if (position == ZFProgressHUDPosition_Center) {
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.bezelView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0]];
    }
    else if (position == ZFProgressHUDPosition_Bottom) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.bezelView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
    }
    else {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.bezelView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    }
    
    [self applyPriority:998.f toConstraints:constraints];
    return constraints;
}

- (NSArray *)bezelSideConstraints:(ZFProgressHUDPosition)position {
    NSMutableArray *constraints = [NSMutableArray array];
    
    NSDictionary *metrics = @{@"margin": @(self.margin)};
    UIView *bezel = self.bezelView;
    
    if (position == ZFProgressHUDPosition_Center) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[bezel]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bezel)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=margin)-[bezel]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bezel)]];
    }
    else if (position == ZFProgressHUDPosition_Bottom) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[bezel]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bezel)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=margin)-[bezel]-(height)-|" options:0 metrics:@{@"height":@(ZFProgressHUDHeightWhenBottomPosition)} views:NSDictionaryOfVariableBindings(bezel)]];
    }
    else {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[bezel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bezel)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bezel(==height)]" options:0 metrics:@{@"height":@(ZFProgressHUDHeightWhenTopPosition)} views:NSDictionaryOfVariableBindings(bezel)]];
    }
    [self applyPriority:998.f toConstraints:constraints];
    return constraints;
}

- (void)applyPriority:(UILayoutPriority)priority toConstraints:(NSArray *)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.priority = priority;
    }
}

#pragma mark-  notification

- (void)onChangeStatusBarOrientationNotification:(NSNotification *)notification {

}

- (void)onKeyboardWillChangeFrame:(NSNotification *)notification {
    
}

- (CGFloat)keyboardHeight {
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if ([[window class] isEqual:[UIWindow class]] == NO) {
            for (UIView *possibleKeyboard in [window subviews]) {
                if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
                    return possibleKeyboard.bounds.size.height;
                }
                else if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"]) {
                    for (UIView *hostKeyboard in [possibleKeyboard subviews]) {
                        if ([[hostKeyboard description] hasPrefix:@"<UIInputSetHost"]) {
                            return hostKeyboard.frame.size.height;
                        }
                    }
                }
            }
        }
    }
    return 0;
}

#pragma mark-   Setter & Getter

- (void)setMode:(ZFProgressHUDMode)mode {
    _mode = mode;
    
    UIView *indicator = self.indicator;
    BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
    if (mode == ZFProgressHUDMode_Indeterminate) {
        if (!isActivityIndicator) {
            // Update to indeterminate indicator
            [indicator removeFromSuperview];
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [(UIActivityIndicatorView *)indicator startAnimating];
            [self.bezelView addSubview:indicator];
        }
    }
    else if (mode == ZFProgressHUDMode_OnlyText) {
        [indicator removeFromSuperview];
        indicator = nil;
    }
    else if (mode == ZFProgressHUDMode_CustomView && self.customView != indicator) {
        [indicator removeFromSuperview];
        indicator = self.customView;
        [self.bezelView addSubview:indicator];
    }
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicator = indicator;
    [self setNeedsUpdateConstraints];
}

- (void)setPosition:(ZFProgressHUDPosition)position {
    _position = position;
    
    [self removeConstraints:self.constraints];
    [self addConstraints:[self bezelPositionConstraints:position]];
    [self addConstraints:[self bezelSideConstraints:position]];
}

- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    self.titleLabel.textColor = contentColor;
    self.detailLabel.textColor = contentColor;
    
    UIView *indicator = self.indicator;
    if ([indicator isKindOfClass:[UIActivityIndicatorView class]]) {
        UIActivityIndicatorView *appearance = nil;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 90000
        appearance = [UIActivityIndicatorView appearanceWhenContainedIn:[ZFProgressHUD class], nil];
#else
        // For iOS 9+
        appearance = [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[ZFProgressHUD class]]];
#endif
        if (appearance.color == nil) {
            ((UIActivityIndicatorView *)indicator).color = contentColor;
        }
    }
}

- (ZFBackgroundView *)backgroundView {
    if (_backgroundView) return _backgroundView;
    ZFBackgroundView *backgroundView = [[ZFBackgroundView alloc] initWithFrame:self.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.alpha = 0.f;
    _backgroundView = backgroundView;
    return _backgroundView;
}

- (ZFBackgroundView *)bezelView {
    if (_bezelView) return _bezelView;
    
    ZFBackgroundView *bezelView = [ZFBackgroundView new];
    bezelView.style = ZFProgressHUDBackgroundStyle_BlurDark;
    bezelView.translatesAutoresizingMaskIntoConstraints = NO;
    bezelView.layer.cornerRadius = 5.f;
    bezelView.alpha = 0.f;
    _bezelView = bezelView;
    
    return _bezelView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    UILabel *titleLabel = [UILabel new];
    titleLabel.adjustsFontSizeToFitWidth = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:ZFDefaultLabelFontSize];
    titleLabel.opaque = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel = titleLabel;

    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel) return _detailLabel;
    UILabel *detailLabel = [UILabel new];
    detailLabel.adjustsFontSizeToFitWidth = NO;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont boldSystemFontOfSize:ZFDefaultDetailLabelFontSize];
    detailLabel.opaque = NO;
    detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel = detailLabel;
    return _detailLabel;
}

@end


#pragma mark-  ZFBackgroundView

@interface ZFBackgroundView ()

@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation ZFBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.layer.allowsGroupOpacity = NO;
    [self addSubview:self.effectView];
    self.style = ZFProgressHUDBackgroundStyle_ClearColor;
}

#pragma mark-   Setter & Getter

- (void)setStyle:(ZFProgressHUDBackgroundStyle)style {
    _style = style;
    if (style == ZFProgressHUDBackgroundStyle_ClearColor) {
        self.backgroundColor = [UIColor clearColor];
        self.effectView.hidden = YES;
    }
    else {
        self.effectView.hidden = NO;
        UIBlurEffectStyle effectStyle = UIBlurEffectStyleDark;
        if (style == ZFProgressHUDBackgroundStyle_BlurExtraLight) {
            effectStyle = UIBlurEffectStyleExtraLight;
            [(ZFProgressHUD *)self.superview setContentColor:[UIColor colorWithWhite:0.f alpha:0.7]];
        }
        else if (style == ZFProgressHUDBackgroundStyle_BlurLight) {
            effectStyle = UIBlurEffectStyleLight;
            [(ZFProgressHUD *)self.superview setContentColor:[UIColor colorWithWhite:0.f alpha:0.7]];
        }
        UIColor *darkStyleContentColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        UIColor *otherStyleContentColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [(ZFProgressHUD *)self.superview setContentColor:effectStyle == UIBlurEffectStyleDark ? darkStyleContentColor : otherStyleContentColor];
        self.effectView.effect = [UIBlurEffect effectWithStyle:effectStyle];
    }
}

- (UIVisualEffectView *)effectView {
    if (_effectView) return _effectView;
    
    UIVisualEffectView *effectView = [UIVisualEffectView new];
    [self addSubview:effectView];
    effectView.frame = self.bounds;
    effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _effectView = effectView;
    return _effectView;
}

@end
