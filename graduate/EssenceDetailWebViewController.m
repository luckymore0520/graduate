//
//  BBSDetail.m
//  MobileNJU
//
//  Created by luck-mac on 14-5-29.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "EssenceDetailWebViewController.h"
#import "MEssenceDetail.h"
#import "MEssenceCollect.h"
#import "MEssence.h"
#define GESTURE_STATE_START 1
#define GESTURE_STATE_END 2
#define GESTURE_STATE_MOVE 3

@interface EssenceDetailWebViewController ()<UIWebViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) NSString* imgURL;
@property (nonatomic,strong)NSTimer* time;
@property (nonatomic)int gesState;
@property (nonatomic,strong) MEssence* essence;
@property (weak, nonatomic) IBOutlet UIButton *essenceCollectButton;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *essenceShareButton;

@end


@implementation EssenceDetailWebViewController

static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView setDelegate:self];
    
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
    if (self.postId) {
        [[[MEssenceDetail alloc]init]load:self id:self.postId];
    } else {
        [self.essenceCollectButton setHidden:YES];
        [self.essenceShareButton setHidden:YES];
    }
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(processShareSuccess) name:@"shareSuccess" object:nil];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MEssenceDetail"])
    {
        self.essence = [MEssence objectWithKeyValues:data];
        if (self.essence.isCollected_.integerValue==1) {
            [self.essenceCollectButton setSelected:YES];
        }
    } else if ([names isEqualToString:@"MEssenceCollect"])
    {
        if (self.essenceCollectButton.selected) {
            [ToolUtils showToast:@"收藏成功" toView:self.view];
            
        } else {
            [ToolUtils showToast:@"已取消收藏" toView:self.view];
        }
    }
}

- (void)addMask
{
    if (!self.maskView) {
        self.maskView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        [self.maskView setAlpha:0.5];
        [self.maskView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:self.maskView];
    }
    [self.maskView setHidden:NO];
}


- (IBAction)collect:(id)sender {
    [[[MEssenceCollect alloc]init]load:self id:self.essence.id_ type:self.essenceCollectButton.selected?0:1];
    [self.essenceCollectButton setSelected:!self.essenceCollectButton.selected];
}
-(void)hideShareView
{
    [self removeMask];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, 0);
    }];
}
- (IBAction)cancelShare:(id)sender {
    [self hideShareView];
}

- (IBAction)share:(id)sender {
    [self addMask];
    [self.view bringSubviewToFront:self.shareView];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, -self.shareView.frame.size.height);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *requestString =  [[_request URL]   absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX =  [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                if (_imgURL) {
                    
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
            else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            [_time invalidate];
            _time = nil;
            _gesState = GESTURE_STATE_END;
            NSLog(@"touch end");
            }
        }
        return NO;
    }
    return YES;
}

- (void)handleLongTouch {
    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片"]) {
        
        
        if (_imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:_imgURL];
        NSLog(@"image url=%@", urlToSave);
        NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:urlToSave];
        [myThread start];
       
    }
}

- (void)downloadImage:(NSString*) urlToSave
{
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
    UIImage* image = [UIImage imageWithData:data];
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
            [ToolUtils showMessage:@"保存失败"];
        }else {
            NSLog(@"OK");
            [ToolUtils showMessage:@"保存成功"];
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
}


- (void)addRightButton
{
    [self addRightButton:@"更多精华" action:@selector(showMore) img:nil];
}

- (void)showMore
{
    BaseFuncVC* more = (BaseFuncVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"essenceRoot"];
    [self.navigationController pushViewController:more
                                         animated:YES];
}

#pragma mark -sharebuttons

- (IBAction)qqShare:(UIButton *)sender
{
    self.essence.hasDownload_ = @1;
    [ShareApiUtil qqShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl] from:self];
}

- (IBAction)friendsShare:(UIButton *)sender {
    [ShareApiUtil weixinShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]scene:WXSceneTimeline];
}
- (IBAction)weixinShare:(UIButton *)sender {
    [ShareApiUtil weixinShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]scene:WXSceneSession];
}


- (IBAction)weiboShare:(UIButton *)sender {
    // AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [ShareApiUtil weiboShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]];
}

-(void)processShareSuccess{
    [self hideShareView];
    self.essence.hasDownload_ = @1;
    [ShareApiUtil showShareSuccessAlert];
}

-(NSString *)getShareTitle
{
    return self.essence.title_;
}

-(NSString *)getShareUrl
{
    return self.essence.url_;
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
    //[self processShareSuccess];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)onReq:(QQBaseReq *)req
{
    NSLog(@"过来了");
    
}
- (void)onResp:(QQBaseResp *)resp
{
    NSLog(@"过来了");
}
- (void)isOnlineResponse:(NSDictionary *)response
{
}

@end
