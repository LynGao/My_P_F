//
//  BottomThumbView.m
//  MyPdf
//
//  Created by gao wenjian on 14-2-20.
//
//

#import "BottomThumbView.h"
#import "PdfUtil.h"
#import "Model.h"
#import "Util.h"

@interface BottomThumbView()
{
    UIScrollView *_thumbSrollView;
}
@end

@implementation BottomThumbView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ThumbGenSuccess"
                                                  object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(genThumbSuccess)
                                                     name:@"ThumbGenSuccess"
                                                   object:nil];
        
        _thumbSrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_thumbSrollView setBackgroundColor:[UIColor whiteColor]];
        [_thumbSrollView setShowsHorizontalScrollIndicator:NO];
        [_thumbSrollView setShowsVerticalScrollIndicator:YES];
        [_thumbSrollView setContentOffset:CGPointZero];
        [_thumbSrollView setContentSize:CGSizeZero];
        [self addSubview:_thumbSrollView];
        
        UILabel *liner = [[UILabel alloc] initWithFrame:CGRectMake(0,  _thumbSrollView.frame.origin.y, _thumbSrollView.frame.size.width, 1)];
        [liner setBackgroundColor:[UIColor blackColor]];
        [self addSubview:liner];

    }
    return self;
}

- (void)genThumbSuccess
{
    NSArray *thumbArray = [[PdfUtil shareInstant] getThumbArray:@"a"];
    NSMutableArray *sortName = [NSMutableArray array];
    for (NSString *name in thumbArray) {
        Model *m = [[Model alloc] init];
        NSArray *array = [name componentsSeparatedByString:@"."];
        [m setName:[[array objectAtIndex:0] integerValue]];
        [sortName addObject:m];
    }
    
    NSArray *sortResult = [Util sortArrayByCondition:@"name" dataArray:sortName];
    
    [sortResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *thumb = [[UIImageView alloc] initWithFrame:CGRectMake(5 + 40*idx + 5 * idx, 2, 40, 50)];
        Model *m = (Model *)obj;
        NSString *fileName = [NSString stringWithFormat:@"%@/%@",FILEPATH(@"a"),[NSString stringWithFormat:@"%d.png",m.name]];
        [thumb setImage:[UIImage imageWithContentsOfFile:fileName]];
        [_thumbSrollView addSubview:thumb];

    }];
    
    [_thumbSrollView setContentSize:CGSizeMake(40 * thumbArray.count + 5*(thumbArray.count + 1), 50)];
}

@end
