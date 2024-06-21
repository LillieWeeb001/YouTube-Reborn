#import "ChangelogsController.h"

@interface ChangelogsController ()
@end

@implementation ChangelogsController

- (void)loadView {
	[super loadView];
    
    WKWebView *rebornChangelogsWebView = [[WKWebView alloc] initWithFrame:self.view.frame];  
    [rebornChangelogsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://ytreborn.lillieh1000.gay/changelogs.html"]]];
    rebornChangelogsWebView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:rebornChangelogsWebView];
}

@end