//
//  ViewController.m
//  YYBarrageView
//
//  Created by MAC on 2017/10/12.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "YYBarrageView.h"

@interface ViewController () {
    YYBarrageView *_barrageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setTitle:@"start" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:start];
    start.frame = CGRectMake(self.view.center.x-40, 300, 80, 30);
   
    UIButton *stop = [UIButton buttonWithType:UIButtonTypeCustom];
    [stop setTitle:@"stop" forState:UIControlStateNormal];
    [stop setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:stop];
    stop.frame = CGRectMake(self.view.center.x-40, 350, 80, 30);
    
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [stop addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *titles = [NSMutableArray arrayWithArray:
                                                 @[@"哈哈哈😄🐶🐷",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄",
                                                   @"哈哈哈😄🐶",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈",
                                                   @"哈哈哈😄🐶🐷哈哈哈😄🐶🐷哈哈哈😄🐶"
                                                   ]];
    
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0 ; i < 30; i++) {
        
        NSInteger index = arc4random()%titles.count;
        NSInteger iconIndex = arc4random()%7;
        NSString *con = [NSString stringWithFormat:@"弹幕%d%@",i,titles[index]];
        YYBarrageSubviewModel *model = [[YYBarrageSubviewModel alloc] init];
        model.contentString = con;
        model.iconNameString = [NSString stringWithFormat:@"%ld",(long)iconIndex];
        [datas addObject:model];
    }
    
    _barrageView = [[YYBarrageView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 150)];
    _barrageView.datas = datas;
    [self.view addSubview:_barrageView];
    _barrageView.backgroundColor = [UIColor cyanColor];
    
}

- (void)start {
    [_barrageView start];
}

- (void)stop {
    [_barrageView stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
