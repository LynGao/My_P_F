//
//  ViewController.m
//  MyPdf
//
//  Created by wenjian gao on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "NewPdfView.h"
#import "PdfViewController.h"
#import "PdfUtil.h"
#import "BottomThumbView.h"
#import "PdfHeaderBar.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
{
    UIPageViewController *_pageController;
    NSInteger _totalPage;
    PdfHeaderBar *_headerBar;
    BottomThumbView *_bottomBar;
}
@property (nonatomic,strong) NSArray *pageContent;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _totalPage = [[PdfUtil shareInstant] getPdfPageCount];

    [self createContentPages];
    
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone],UIPageViewControllerOptionSpineLocationKey ,nil];
    
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    [_pageController setDataSource:self];
    [_pageController.view setFrame:self.view.bounds];
    
    [self jumpPageAtIndex:0
                 animated:NO];

    [self.view addSubview:_pageController.view];
    
    _headerBar = [[PdfHeaderBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)
                                            onTarget:self];
    [self.view addSubview:_headerBar];
        
    _bottomBar = [[BottomThumbView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 50)];
    [self.view addSubview:_bottomBar];
    
    [[PdfUtil shareInstant] createPDFThumbnailForFile:@"a"];
    
    
//    MPMoviePlayerController *player =[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://v.youku.com/v_show/id_XNjcyOTM0NDUy.html?f=21969953&ev=4"]];
//    player.controlStyle = MPMovieSourceTypeStreaming;
//    player.movieSourceType = MPMovieSourceTypeStreaming;
//    [player prepareToPlay];
//    [player.view setFrame:self.view.bounds];  // player的尺寸
//    [self.view addSubview: player.view];
//    player.shouldAutoplay=YES;
//    [player play];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)back
{
   
}



#pragma mark -- 初始化所有数据
- (void) createContentPages {
    NSMutableArray *pagesIndex = [[NSMutableArray alloc] init];
    for (int i = 1; i < _totalPage + 1; i++){
        [pagesIndex addObject:[NSNumber numberWithInt:i]];
    }
    self.pageContent = [[NSArray alloc] initWithArray:pagesIndex];
}

#pragma mark -- jump page
- (void)jumpPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
    PdfViewController *initialViewController = [self viewControllerAtIndex:index];
    NSArray *viewcontrollers = [NSArray arrayWithObjects:initialViewController
                                , nil];
    [_pageController setViewControllers:viewcontrollers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:animated
                             completion:^(BOOL finished) {
                                 
                             }];
}

#pragma mark -- 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(PdfViewController *)viewController {
    NSLog(@"--- %d",viewController.pageIndex);
    return viewController.pageIndex - 1;
}

#pragma mark -- 获取对应的controller
- (PdfViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return nil;
    }
    //创建一个新的控制器类，并且分配给相应的数据
    PdfViewController *dataViewController =[[PdfViewController alloc] init];
    int i = [[self.pageContent objectAtIndex:index] intValue];
    [dataViewController setPageIndex:i];
    return dataViewController;
}

#pragma mark -- data source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PdfViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PdfViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options:UIViewAnimationOptionShowHideTransitionViews
//                     animations:^{
//                         if (_headerBar.alpha == 0) {
//                             _headerBar.alpha = 1;
//                             _bottomBar.alpha = 1;
//                         }else{
//                             [_headerBar setAlpha:0];
//                             [_bottomBar setAlpha:0];
//                         }
//    }
//                     completion:^(BOOL finished) {
//                         
//    }];
}

@end
