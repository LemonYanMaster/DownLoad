//
//  ViewController.m
//  DownLoadDemo
//
//  Created by pengpeng yan on 16/2/15.
//  Copyright © 2016年 peng yan. All rights reserved.
//

#import "ViewController.h"

#define MP4URL @"http://120.25.226.186:32812/resources/videos/minion_03.mp4"

@interface ViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong)NSFileHandle *handle;//文件句柄对象
@property(nonatomic,strong)NSString *fullPath;//文件路径对象
@property(nonatomic,assign)NSInteger totalSzie;//文件总长度对象
@property(nonatomic,assign)NSInteger currentSzie;//当前的文件长度;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self downLoad];
}

- (void)downLoad{
    NSURL *url = [NSURL URLWithString:MP4URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.0;
    
//    [NSURLConnection connectionWithRequest:request delegate:self];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
//    UIApplication *app = [UIApplication sharedApplication];
//    app.networkActivityIndicatorVisible = YES;
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:nil];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //获取文件的总大小
    self.totalSzie = response.expectedContentLength;
    //获取文件名
    NSString *fileName = response.suggestedFilename;
    
    //文件的全路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //拼接路径
    NSString *path = [caches stringByAppendingPathComponent:fileName];
    self.fullPath = path;
    
    //创建一个文件夹
    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    
    //创建一个文件句柄
    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   //把文件句柄移动到文件的末尾
    [self.handle seekToEndOfFile];
    
   //使用文件句柄写入数据
    [self.handle writeData:data];
    
    self.currentSzie += data.length;
    NSLog(@"%f",1.0* self.currentSzie / self.totalSzie);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"----%@---",self.fullPath);
   //关闭文件句柄 置空指针
    [self.handle closeFile];
    self.handle = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


@end
