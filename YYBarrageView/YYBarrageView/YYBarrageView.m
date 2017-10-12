//
//  YYBarrageView.m
//  YYBarrageView
//
//  Created by MAC on 2017/10/12.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "YYBarrageView.h"

@interface YYBarrageView ()
@property (nonatomic ,strong) NSMutableSet <YYBarrageSubview *> *visibleBarrageSubviews;//可视弹幕view
@property (nonatomic ,strong) NSMutableSet <YYBarrageSubview *> *reusableBarrageSubviews;//复用池弹幕view
@property (nonatomic ,assign) NSInteger barrageIndex;// 弹幕索引
@property (nonatomic ,assign) BOOL isStop;
@end

@implementation YYBarrageView

// 复用弹幕view
- (YYBarrageSubview *)dequeueReusableBarrageSubview {

    YYBarrageSubview *barrageSubview = [self.reusableBarrageSubviews anyObject];
    if (barrageSubview) {
        [self.reusableBarrageSubviews removeObject:barrageSubview];
    } else {
        barrageSubview = [[YYBarrageSubview alloc] init];
    }
    return barrageSubview;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isStop = YES;
        _barrageIndex = 0;
    }
    return self;
}

- (void)setDatas:(NSMutableArray<YYBarrageSubviewModel *> *)datas {
    _datas = datas;
    if (datas.count > 1) {
        self.visibleBarrageSubviews = [NSMutableSet set];
        self.reusableBarrageSubviews = [NSMutableSet set];
    }
}

- (void)start {
    if (!_isStop) return;
    if (self.datas.count<=0) return;
    _isStop = NO;
    [self setupBarrageSubViews];
}

- (void)setupBarrageSubViews {
    //设置弹道数量
    NSMutableArray *tracks = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) {
        
        //获取随机弹道
        NSInteger index = arc4random()%tracks.count;
        NSInteger track = [[tracks objectAtIndex:index] integerValue];
        [tracks removeObjectAtIndex:index];
        
        YYBarrageSubviewModel *model = [self.datas objectAtIndex:i];

        self.barrageIndex = i;
        [self createBarrageSubview:model track:track];
    }
}

- (void)createBarrageSubview:(YYBarrageSubviewModel *)model track:(NSInteger)track {
    if (_isStop) return;
    
    YYBarrageSubview *barrageSubview = [self dequeueReusableBarrageSubview];
    barrageSubview.model = model;
    barrageSubview.track = track;
    
    __weak typeof(barrageSubview) weakview = barrageSubview;
    __weak typeof(self) mySelf = self;
    barrageSubview.movingStateBlock = ^(YYBarrageMoveState state){
        if (_isStop) return ;
        
        switch (state) {
                
            case YYBarrageMoveStateStart: {
                [mySelf.visibleBarrageSubviews addObject:weakview];
            }
                 break;
            case YYBarrageMoveStateEnter: {
                (self.barrageIndex < self.datas.count) ?  self.barrageIndex ++  : 0;
                if (self.barrageIndex>=self.datas.count) {
                    self.barrageIndex = 0;
                }
                
                //弹幕完全进入屏幕时 如果还有内容将继续获取后面的内容 （递归）
                YYBarrageSubviewModel *model = [mySelf.datas objectAtIndex:self.barrageIndex];
                if (model) {
                    [mySelf createBarrageSubview:model track:track];
                }
            }
                break;
            case YYBarrageMoveStateEnd:{
                
                //动画结束处理
                if ([mySelf.visibleBarrageSubviews containsObject:weakview]) {
                    
                    [weakview stopAnimation];
                   
                    [mySelf.reusableBarrageSubviews addObject:weakview];
                    [mySelf.visibleBarrageSubviews minusSet:mySelf.reusableBarrageSubviews];
                    [mySelf.visibleBarrageSubviews removeObject:weakview];
                }
                //执行完毕可循环播放
                if (mySelf.visibleBarrageSubviews.count == 0) {
                    mySelf.isStop = YES;
                    [mySelf start];
                }
            }
                break;
                
            default:
                break;
        }
    };
    
    [self addSubview:barrageSubview];
    barrageSubview.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 10+barrageSubview.track*50, CGRectGetWidth(barrageSubview.bounds), CGRectGetHeight(barrageSubview.bounds));
    [barrageSubview startAnimation];
}

- (void)stop {
    if (_isStop) return;
    _isStop = YES;
    _barrageIndex = 0;
    while (self.subviews.count) {
        [(YYBarrageSubview *)self.subviews.lastObject stopAnimation];
        [self.subviews.lastObject removeFromSuperview];
    }
    
    [self.visibleBarrageSubviews removeAllObjects];
    [self.reusableBarrageSubviews removeAllObjects];
}

@end

@implementation YYBarrageSubview {
    UILabel *_contentLabel;
    UIImageView *_iconImageView;
}

#define margin 10
#define IMG_height 40

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentLabel = [UILabel new];
        [self addSubview:_contentLabel];
        
        _iconImageView = [UIImageView new];
        [self addSubview:_iconImageView];
        
        _iconImageView.backgroundColor = [UIColor whiteColor];
        
        _iconImageView.layer.cornerRadius = IMG_height / 2;
        _iconImageView.layer.masksToBounds = YES;
        
        _contentLabel.font = [UIFont systemFontOfSize:15];
        self.layer.cornerRadius = 15;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setModel:(YYBarrageSubviewModel *)model {
    if (_model != model) {
        _model = model;
        _contentLabel.text = model.contentString;
        _iconImageView.image = [UIImage imageNamed:model.iconNameString];
        
        CGFloat width = [_model.contentString sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}].width;
        self.frame = CGRectMake(0, 0, width + IMG_height + margin * 2, 30);
        _iconImageView.frame = CGRectMake(-5, -10, IMG_height, IMG_height);
        _contentLabel.frame = CGRectMake(IMG_height + 5, 0, width, 30);
    }
}

- (void)startAnimation {
    
    // 根据弹幕的长度执行动画效果
    // 根据 速度 = 宽度 / 时间
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat time = 4.0f;
    CGFloat totalWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //开始状态回调
    if (self.movingStateBlock) {
        self.movingStateBlock(YYBarrageMoveStateStart);
    }
    
    //时间 = 宽度 / 速度
    CGFloat speed = totalWidth / time;
    CGFloat enterTime = CGRectGetWidth(self.bounds)/speed + 0.15;
    //通过时间计算出弹幕完全进入屏幕的状态
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterTime];
    
    
    // 通过动画改变X 实现自动滚动
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        frame.origin.x -= totalWidth;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            //完全离开屏幕回调
            if (self.movingStateBlock) {
                self.movingStateBlock(YYBarrageMoveStateEnd);
            }
        }
    }];
    
}
- (void)enterScreen {
    //完全进入屏幕回调
    if (self.movingStateBlock) {
        self.movingStateBlock(YYBarrageMoveStateEnter);
    }
}

- (void)stopAnimation {
    //移除延时执行的方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end


@implementation YYBarrageSubviewModel
@end
