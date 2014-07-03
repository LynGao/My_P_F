//
//  PdfViewController.m
//  MyPdf
//
//  Created by gao wenjian on 14-2-18.
//
//

#import "PdfViewController.h"
#import "NewPdfView.h"
@interface PdfViewController ()
{

}
@end

@implementation PdfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    NewPdfView *pdfView = [[NewPdfView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height)];
    [pdfView setPageIndex:self.pageIndex];
    [self.view addSubview:pdfView];
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
