//
//  ViewController.m
//  UIScrollView-Cycle
//
//  Created by zhangbin on 16/6/11.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,weak)UIImageView *centerImageV;
@property(nonatomic,weak)UIImageView *reuseImageV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = self.view.bounds;//  x和y呢
    // 图片的宽度
    CGFloat w = self.view.frame.size.width;
    // 图片的高度
    CGFloat h = self.view.frame.size.height;
    //设置ScrollView初始化属性
    //设置分页效果
    self.scrollView.pagingEnabled = YES;
    //初始化ScollView的内容大小，也就是可以滚动的范围。我们滚动ScollView的内容时,内容中的某张图片与scrollView(等价于屏幕)重合的话，这张图片就会被我们看到。
    // 精华:ScollView就是一个供我们看东西的窗口，没有其他用
    self.scrollView.contentSize = CGSizeMake(3 *w , h);
    //隐藏垂直滚动条
    self.scrollView.showsVerticalScrollIndicator = YES;
    //设置ScrollView代理
    self.scrollView.delegate = self;
    //创建一个可见的UIImageView(也就是中间的UIImageView),并默认显示一张图片
    UIImageView  *centerImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"00"]];
    //记录住中间的centerImageV.
    self.centerImageV = centerImageV;
    
    //设置中间图片的x值为一个屏幕的宽度，运行程序时第一个看到的图片就是这个中间的图片
    self.centerImageV.frame = CGRectMake(w, 0, w, h);
    
    self.centerImageV.tag = 0;
    // 把图片添加到UIScrollView上.本质上是把图片添加到了UIScrollView的内容上。我们滚动屏幕时，滚动的不是UIScrollView，而是内容.因为图片添加到了内容上，所以我们手动滚动内容时(也可以利用代码控制contentOffset的偏移量实现滚动内容)，图片会经过这个UIScrollView(窗口)，经过窗口的内容会被我们看到。如果你认为图片添加到了UIScrollView这个控件上，假设图片添加到了UIScrollView的frame的外侧，也就是屏幕的外侧，这样我们无论怎么滚动，也永远看不到这张图片，因为UIScrollView此时就是一个供我们看东西的窗口，超过窗口的东西我们永远看不到，你把图片添加到了这个窗口的外侧，而不是添加到了内容上，你滚动内容时，内容里面并没有图片，内容经过窗口时，怎么会显示这张图片？
    // 为什么能滚动？contentSize不能滚动，contentSize仅仅是提供了一个供我们滚动的矩形范围。scrollView的内容能滚动(前提:我们必须用手滚内容啊，只要触摸到了内容，就能滚，底层帮我们做好了，不要问为什么)。内容的载体是虚拟的，我们看不到，但是内容我们是能看到的，在UIScrollView中，内容就是图片。在UITableView中，内容包括cell、
    // 如果你现在仍理解为把图片添加到UIScrollView上，你就无法理解滚动的谁？为什么能滚动？窗口是谁？contentSize的深层次含义？
    // 看UITableView动态截图+ppt截图你就理解UIScrollView了:UITableView控件并不能滚动，而是内容能滚动。

    [self.scrollView addSubview:self.centerImageV];
     //创建一个可重复利用的reuseImageV,也就是下一次滚动出来的图片.
    UIImageView *reuseImageV = [[UIImageView alloc]init];
    //记录住reuseImageV
    self.reuseImageV = reuseImageV;
    // 只设置了可重复利用reuseImageV的宽和高，而x和y并没有设置，所以不会显示
    self.reuseImageV.frame = self.view.bounds;
    //把图片添加到ScrollView上.
    [self.scrollView addSubview:self.reuseImageV];
    // 把scrollView添加到当前控制器的view中
    [self.view addSubview:self.scrollView];
    
    // 初始化scrollView的偏移量.一开始显示中间部分.
    self.scrollView.contentOffset = CGPointMake(w, 0);
    
}
//当ScorllView滚动时调用.目的:根据左滚右滚的不同情况，将图片添加到不同的位置上
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 获取ScrollView X轴方向的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    //记录ScollView的宽度.
    CGFloat w =  scrollView.frame.size.width;
    //设置循环利用View的位置.
    CGRect reuserImageVFrame = self.reuseImageV.frame;
    //记录当前是第几页(因为滚动内容就会调用,所以刚开始滚动时，当前页还没有翻过去，所以肯定是第0页)
    NSInteger index = 0;
    
    //判断内容是向左滚动还是向右滚动
    
    // 如果当前的偏移量刚刚大于中间图片的x值，说明content向左滚动，此时立刻让reuseImageV添加到中间图片的后面
    if (offsetX > self.centerImageV.frame.origin.x) {
         //让重复利用的图片X在中间ImageView的后面.
        reuserImageVFrame.origin.x = CGRectGetMaxX(self.centerImageV.frame);
        //设置页数+1.
        index = self.centerImageV.tag + 1;
        // 页数小于总页数，说明图片还没有滚完，就不执行{}中的内容
        if(index > 7){
            // 如果页数大于总个数.从第0页开始.
            index = 0;
        }
    }else{// 内容向右滚动
        // 设置重复利用的图片X在左侧,0的位置
        reuserImageVFrame.origin.x = 0;
        //设置页数-1
        index = self.centerImageV.tag  -1;
         //如果页数小于0页.
        if (index < 0) {
             //从最后一页开始.
            index = 6;
        }
    
    }
    // 设置重复利用的图片的位置
    self.reuseImageV.frame = reuserImageVFrame;
    // 记录当前重复利用的图片是第几页(如果之前已经进行了 index = self.centerImageV.tag + 1;)所以页数加1
    self.reuseImageV.tag = index;
    NSLog(@"%ld",index);
    // 设置图片名称
    NSString *imageName = [NSString stringWithFormat:@"0%ld",index];
    // 显示重复利用的图片
    self.reuseImageV.image = [UIImage imageNamed:imageName];
     //如果继续滚动到最向右滚动,或者继续向左滚动，就执行{ }
    if (offsetX <= 0 || offsetX >= 2 *w) {
        //交换中间的图片 和 重复利用图片两个指针，指针名不会变，变得是指针中存储的内容.
        UIImageView *tempImage = self.centerImageV;
        self.centerImageV = self.reuseImageV;
        self.reuseImageV = tempImage;
        //交换两个图片的位置.
        self.centerImageV.frame = self.reuseImageV.frame;
        //再次初始化scrollView的偏移量.一开始显示中间部分.
        self.scrollView.contentOffset = CGPointMake(w, 0);
    }

}

@end
