//
//  YMYScrollView.m
//  ScrollView
//
//  Created by Yang on 2017/8/1.
//  Copyright © 2017年 A589. All rights reserved.
//

#import "YMYScrollView.h"
#define CalculateIndex(x,y) (x+y)%y  //计算循环索引



@interface YMYScrollView ()<UIScrollViewDelegate>
@property (nonatomic, readwrite, strong)UIImageView * leftImageView;
@property (nonatomic, readwrite, strong)UIImageView * middleImageView;
@property (nonatomic, readwrite, strong)UIImageView * rightImageView;
@property (nonatomic, readwrite, strong)UIScrollView * containerView;
@property (nonatomic, readwrite, strong)NSTimer *timer;

@property NSInteger currentNumber;
@end

@implementation YMYScrollView


-(instancetype)initWithImages:(NSArray *)images withPageStyle:(YMYScrollViewPageStyle)pagestyle withPageChangeTime:(NSTimeInterval)changeTime withFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.frame = frame;
        _images = [[NSArray alloc] initWithArray:images];
        _pageStyle = pagestyle;
        _pageChangeTime = changeTime;
        _currentNumber = 0;
        
        //初始化三个imageView和ScrollView
        [self setImageViewAndScrollView];
        
        //配置pageControl 初始化等
        [self setPageControlView];
        
        //初始化图片描述
        [self setImageDescrip];
        
        //设置三个imageview的初始image，如果没有设置image 则直接跳过
        [self setImage];
        
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer   alloc]initWithTarget:self action:@selector(clickPageAction)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)clickPageAction{
    [self.delegate clickWithPage:self.currentNumber];

}

-(void)setImageViewAndScrollView{
    //初始化三个imageView和scrollView
    _containerView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _containerView.contentSize = CGSizeMake(3*_containerView.frame.size.width, _containerView.frame.size.height);
    _containerView.contentOffset = CGPointMake(_containerView.frame.size.width, _containerView.frame.origin.y);//显示中间图片
    _containerView.delegate = self;
    _containerView.backgroundColor = [UIColor grayColor];
    self.leftImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0  , _containerView.frame.size.width, _containerView.frame.size.height)];
    
    self.middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_containerView.frame.size.width, 0  , _containerView.frame.size.width, _containerView.frame.size.height)];
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*_containerView.frame.size.width, 0, _containerView.frame.size.width, _containerView.frame.size.height)];
    [_containerView addSubview:_leftImageView];
    [_containerView addSubview:_rightImageView];
    [_containerView addSubview:_middleImageView];
    _containerView.scrollEnabled = YES;
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.pagingEnabled = YES;
    
    [self addSubview:_containerView];
}

- (void)setPageControlView{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPage = 0;
    [self pageControlStyle:_pageStyle];
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = _images.count;
}
/**
 *  确定pageControl的位置，可以自定义设置 有三个位置：下左，下中，下右
 */
- (void)pageControlStyle:(YMYScrollViewPageStyle)style{
    if (style == center ) {
        _pageControl.frame = CGRectMake(self.center.x - 50, self.frame.size.height -30, 100, 30);
    }else if (style == left){
        _pageControl.frame = CGRectMake(50, self.frame.size.height -30, 100, 30);
    }else if (style == right){
        _pageControl.frame = CGRectMake(self.frame.size.width - 100-20, self.frame.size.height -30, 100, 30);
    }
}

- (void)setImageDescrip{
    _pageDescripLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_pageControl.frame.origin.y -10, self.frame.size.width, 40)];
    [_pageDescripLabel setTextAlignment:NSTextAlignmentRight];
    _pageDescripLabel.backgroundColor = [UIColor clearColor];
    _pageDescripLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:_pageDescripLabel];
}

- (void)setImage{
    if ([_images count] == 0) {
        NSLog(@"cycleImageViewConfig:images is empty!");
        return;
    }
    _middleImageView.image = (UIImage *)_images[CalculateIndex(_currentNumber,_images.count)];
    _leftImageView.image = (UIImage *)_images[CalculateIndex(_currentNumber - 1,_images.count)];
    _rightImageView.image = (UIImage *)_images[CalculateIndex(_currentNumber + 1,_images.count)];
    //设置定时器
    [self timeSetter];
}
//设置定时器
- (void)timeSetter{
    //将定时器放入主进程的RunLoop中
    self.timer = [NSTimer timerWithTimeInterval:self.pageChangeTime target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)timeChanged{
    if (_images.count == 0) {
        NSLog(@"timeChanged:images is empty!");
        return;
    }
    self.currentNumber =  CalculateIndex(_currentNumber+1,_images.count);
    self.pageControl.currentPage = self.currentNumber;
    [self setPageDescripText];
    [self pageChangeAnimationType:1];
    [self changeImageViewWith:self.currentNumber];
    self.containerView.contentOffset = CGPointMake(_containerView.frame.origin.x, _containerView.frame.origin.y);
}
- (void)setPageDescripText
{
    self.pageDescripLabel.text = self.pageDescrips[self.currentNumber];
    [self.pageDescripLabel sizeToFit];
}

- (void)pageChangeAnimationType:(NSInteger)animationType{
    if (animationType == 0) {
        return;
    }else if (animationType == 1) {
        [self.containerView setContentOffset:CGPointMake(2*self.containerView.frame.size.width, 0) animated:YES];
    }else if (animationType == 2){
        self.containerView.contentOffset = CGPointMake(2*self.frame.size.width, 0);
        [UIView animateWithDuration:self.pageChangeTime delay:0.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
        }];
    }
}

/**
 *  改变轮播的图片
 *
 *  @param imageNumber 设置当前，前，后的图片
 */
- (void)changeImageViewWith:(NSInteger)imageNumber
{
    self.middleImageView.image = self.images[CalculateIndex(imageNumber,self.images.count)];
    self.leftImageView.image = self.images[CalculateIndex(imageNumber - 1,self.images.count)];
    self.rightImageView.image = self.images[CalculateIndex(imageNumber + 1,self.images.count)];
}

- (void)setPageDescrips:(NSArray *)pageDescrips{
    _pageDescrips = [[NSArray alloc]initWithArray:pageDescrips];
    [self setPageDescripText];
}



#pragma mark --UIScrollViewDelegate
//当用户手动个轮播时 关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

//当用户手指停止滑动图片时 启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self timeSetter];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = [self.containerView contentOffset];
    if (offset.x == 2*_containerView.frame.size.width) {
        self.currentNumber = CalculateIndex(_currentNumber  + 1,_images.count);
    } else if (offset.x == 0){
        self.currentNumber = CalculateIndex(_currentNumber  - 1,_images.count);
    }else{
        return;
    }
    
    self.pageControl.currentPage = self.currentNumber;
    [self changeImageViewWith:self.currentNumber];
    [self setPageDescripText];
    self.containerView.contentOffset = CGPointMake(_containerView.frame.size.width, _containerView.frame.origin.y);
    
}
@end
