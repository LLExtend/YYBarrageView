//
//  YYBarrageView.h
//  YYBarrageView
//
//  Created by MAC on 2017/10/12.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBarrageSubviewModel;

/** 弹幕管理view */
@interface YYBarrageView : UIView

@property (nonatomic ,strong) NSMutableArray <YYBarrageSubviewModel *> *datas;

- (void)start;
- (void)stop;

@end



typedef NS_ENUM(NSUInteger ,YYBarrageMoveState) {
    YYBarrageMoveStateStart, // 开始
    YYBarrageMoveStateEnter, // 完全进入屏幕
    YYBarrageMoveStateEnd // 完全离开屏幕
};

@interface YYBarrageSubview : UIView
/** 弹幕轨道 */
@property (nonatomic ,assign) NSInteger track;

@property (nonatomic ,copy) void (^movingStateBlock)(YYBarrageMoveState);

//- (instancetype)initWithCoder:(NSCoder *)aDecoder OBJC_UNAVAILABLE("请使用initBarrageSubviewWithModel:初始化");
//
//- (instancetype)initWithFrame:(CGRect)frame OBJC_UNAVAILABLE("请使用initBarrageSubviewWithModel:初始化");
//
//- (instancetype)initBarrageSubviewWithModel:(YYBarrageSubviewModel *)model NS_DESIGNATED_INITIALIZER;

- (void)startAnimation;

- (void)stopAnimation;



@property (nonatomic ,strong) YYBarrageSubviewModel *model;



@end


@interface YYBarrageSubviewModel : NSObject
@property (nonatomic ,copy) NSString *iconNameString;
@property (nonatomic ,copy) NSString *contentString;
@end
