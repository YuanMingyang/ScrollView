//
//  ViewController.m
//  ScrollView
//
//  Created by Yang on 2017/8/1.
//  Copyright © 2017年 A589. All rights reserved.
//

#import "ViewController.h"
#import "YMYScrollView.h"
@interface ViewController ()<YMYScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i <= 6; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cycle_image%ld",(long)i]];
        [images addObject:image];
    }
    YMYScrollView *pageView = [[YMYScrollView alloc] initWithImages:images withPageStyle:center withPageChangeTime:2 withFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/4)];
    pageView.pageDescrips = @[@"第一张",@"第二张",@"第三张",@"第四张",@"第五张",@"第六张"];
    pageView.delegate = self;
    [self.view addSubview:pageView];
}
-(void)clickWithPage:(NSInteger)page{
    NSLog(@"点击了第%lu张",page);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
