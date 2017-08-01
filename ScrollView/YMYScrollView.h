//
//  YMYScrollView.h
//  ScrollView
//
//  Created by Yang on 2017/8/1.
//  Copyright © 2017年 A589. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum{
    left = 0,
    center,
    right
}YMYScrollViewPageStyle;


@protocol YMYScrollViewDelegate <NSObject>

-(void)clickWithPage:(NSInteger)page;

@end

@interface YMYScrollView : UIView
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)NSArray *pageDescrips;
@property(nonatomic,strong)UILabel *pageDescripLabel;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,assign)NSTimeInterval pageChangeTime;
@property(nonatomic,assign)YMYScrollViewPageStyle pageStyle;

@property(nonatomic,assign)id<YMYScrollViewDelegate>delegate;

-(instancetype)initWithImages:(NSArray *)images withPageStyle:(YMYScrollViewPageStyle)pagestyle withPageChangeTime:(NSTimeInterval)changeTime withFrame:(CGRect)frame;
@end
