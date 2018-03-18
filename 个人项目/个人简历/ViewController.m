//
//  ViewController.m
//  个人简历
//
//  Created by 孙金龙 on 2017/12/8.
//  Copyright © 2017年 孙金龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSConditionLock *lock;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"GCD";
    
    // 异步并行
    // [self asyncConcurrent];
    
    // 异步串行
    // [self asyncSerial];
    
    // 同步并行
    // [self syncConcurrent];
    
    // 同步串行
    // [self syncSerial];
    
    // GCD的栅栏方法 dispatch_barrier_async
    // [self barrier];
    
    // GCD延迟执行方法
    // [self dispatch_after];
    
    // dispatch_suspend，dispatch_resume 挂起 开始 队列任务
    // [self dispatch_suspend_And_dispatch_resume];
    
    // “同步”的dispatch_apply
    // [self dispatch_apply];
    
    // dispatch_group
    [self dispatch_group];
    
    // NSConditionLock 线程加锁解锁
    // [self NSConditionLock];
    // Do any additional setup after loading the view, typically from a nib.
}

// 异步并行
- (void)asyncConcurrent
{
    // 创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("bingxing", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"----start");
    // 使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSLog(@"任务1 ----- %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务2 ---- %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务3 ---- %@",[NSThread currentThread]);
    });
    NSLog(@"----end");
}

// 异步串行
- (void)asyncSerial
{
    // 创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("chuanxing", DISPATCH_QUEUE_SERIAL);
    NSLog(@"----start");
    
    // 使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSLog(@"任务1 ----- %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务2 ---- %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务3 ---- %@",[NSThread currentThread]);
    });
    NSLog(@"----end");
}

// 同步并行
- (void)syncConcurrent
{
    // 创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("bingxing", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"-----start");
    
    // 使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1 ----- %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务2 ---- %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务3 ---- %@",[NSThread currentThread]);
    });
    NSLog(@"-----end");
}

// 同步串行队列
- (void)syncSerial
{
    // 创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("chuanxing", DISPATCH_QUEUE_SERIAL);
    NSLog(@"----start");
    
    // 使用异步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1 ----- %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务2 ---- %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务3 ---- %@",[NSThread currentThread]);
    });
    NSLog(@"----end");
}

// 异步任务主队列
- (void)asyncMain
{
    // 放到主队列中的任务只能在主线程中执行所以这里是同步执行
    dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
}

// 同步任务主队列(卡死)
- (void)syncMain
{
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"---start---");
    //使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
}
/*
 总结: 1.能否开启新的线程执行任务看是同步还是异步函数
      2.在子线程中能否多任务并行执行看队列,并行队列可不断开启新的线程并行执行任务
      3.放到主队列中的任务只能在主线程中执行,也就是同步执行
      4.并行和并发的概念:(1)并行 并行不代表同时进行只是表示CPU分配了相同的资源给多个任务
                      (2)并发 并发代表多个任务同时进行多个CPU才能做到
      5.队列底层概念:像是创建了一个runloop,类比主队列-主runloop
*/

// 第二阶段(GCD的一些特殊方法)
- (void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("12312312", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 10; i++)
//        {
//
//        }
//        NSLog(@"----1-----%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 10; i++)
//        {
//
//        }
//        NSLog(@"----2-----%@", [NSThread currentThread]);
//    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----3-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4-----%@", [NSThread currentThread]);
    });
}

// 推迟向队列中提交任务
- (void)dispatch_after
{
    //创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("me.tutuge.test.gcd", DISPATCH_QUEUE_CONCURRENT);
    //立即打印一条信息
    NSLog(@"Begin add block...");
    //提交一个block
    dispatch_async(queue, ^{
        //Sleep 10秒
        [NSThread sleepForTimeInterval:10];
        NSLog(@"First block done...%@",[NSThread currentThread]);
    });

    NSLog(@"11111");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        // 2秒后异步执行这里的代码...
        NSLog(@"run-----%@",[NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
           self.view.backgroundColor = [UIColor purpleColor];
        });
    });
}

// dispatch_suspend，dispatch_resume
// dispatch_suspend，dispatch_resume提供了“挂起、恢复”队列的功能，简单来说，就是可以暂停、恢复队列上的任务。但是这里的“挂起”，并不能保证可以立即停止队列上正在运行的block
- (void)dispatch_suspend_And_dispatch_resume
{
    dispatch_queue_t queue = dispatch_queue_create("me.tutuge.test.gcd", DISPATCH_QUEUE_SERIAL);
    //提交第一个block，延时5秒打印。
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"After 5 seconds...");
        
    });
    
    //提交第二个block，也是延时5秒打印
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"After 5 seconds again...");
    });
    
    //延时一秒
    NSLog(@"sleep 1 second...");
    [NSThread sleepForTimeInterval:1];
    
    //挂起队列
    NSLog(@"suspend...");
    dispatch_suspend(queue);
    
    // 延时执行10秒
    NSLog(@"sleep 10 second...");
    [NSThread sleepForTimeInterval:10];
    
    //恢复队列
    NSLog(@"resume...");
    dispatch_resume(queue);
}

// “同步”的dispatch_apply dispatch_apply的作用是在一个队列（串行或并行）上“运行”多次block，其实就是简化了用循环去向队列依次添加block任务。
- (void)dispatch_apply
{
    //创建异步串行队列
    dispatch_queue_t queue = dispatch_queue_create("me.tutuge.test.gcd", DISPATCH_QUEUE_SERIAL);
    //运行block3次
    dispatch_apply(3, queue, ^(size_t i) {
        NSLog(@"apply loop: %zu", i);
        NSLog(@"%@",[NSThread currentThread]);
    });
    //打印信息
    NSLog(@"After apply");
}

/* 任务组概念 */

// http://www.jianshu.com/p/657e994aeee2 dispatch_group_t 任务组概念 1. 多个网络请求同时请求当所有网络请求都结束时通知刷新界面根据链接内容使用dispatch_group_enter(group)和dispatch_group_leave(group)，这种方式使用更为灵活，enter和leave必须配合使用，有几次enter就要有几次leave，否则group会一直存在。当所有enter的block都leave后，会执行dispatch_group_notify的block。

- (void)dispatch_group
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求1
//        [网络请求:{
//            成功：dispatch_group_leave(group);
//            失败：dispatch_group_leave(group);
        NSLog(@"----barrier1-----%@", [NSThread currentThread]);
        dispatch_group_leave(group);
//        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求2
//        [网络请求:{
//            成功：dispatch_group_leave;
//            失败：dispatch_group_leave;
        NSLog(@"----barrier2-----%@", [NSThread currentThread]);
        dispatch_group_leave(group);
//        }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求3
//        [网络请求:{
//            成功：dispatch_group_leave(group);
//            失败：dispatch_group_leave(group);
        NSLog(@"----barrier3-----%@", [NSThread currentThread]);
        dispatch_group_leave(group);
        
//        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"任务均完成，刷新界面");
    });
    //dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

/* 使用GCD的信号量dispatch_semaphore_t */
// dispatch_semaphore信号量为基于计数器的一种多线程同步机制。如果semaphore计数大于等于1，计数-1，返回，程序继续运行。如果计数为0，则等待。dispatch_semaphore_signal(semaphore)为计数+1操作,dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)为设置等待时间，这里设置的等待时间是一直等待。

// 对于以下代码通俗一点就是，开始为0，等待，等10个网络请求都完成了，dispatch_semaphore_signal(semaphore)为计数+1，然后计数-1返回，程序继续执行。 (这里也就是为什么有个count变量的原因，记录网络回调的次数，回调10次之后再发信号量，使后面程序继续运行)。

-(void)Btn3{
    __block NSInteger count = 0;
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 初始化信号量 此时信号量为0
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    for (int i=0; i<10; i++) {
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"%d---%d",i,i);
            count++;
            if (count==10) {
                // 当10次网络请求都结束时发送信号量 使semaphore计数大于等于1 程序继续运行, 如果计数为0，则等待.
                dispatch_semaphore_signal(sem);
                count = 0;
            }
            
        }];
        
        [task resume];
    }
    // 等待
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
}

// 考虑新需求，10个网络请求顺序回调。 可以用NSConditionLock处理(通过线程加锁解锁的方式来解决)
// NSConditionLock实现了NSLocking协议，一个线程会等待另一个线程unlock或者unlockWithCondition:之后再走lock或者lockWhenCondition:之后的代码。
- (void)NSConditionLock
{
    _lock = [[NSConditionLock alloc] initWithCondition:0];
    dispatch_queue_t queue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<10; i++) {
        NSString *str = @"http://www.jianshu.com/p/6930f335adba";
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(queue, ^{
                [self.lock lockWhenCondition:i];// condition与内部相同才会获取锁对象并立即返回，否则阻塞线程直到condition相同
                NSLog(@"%d---%d",i,i);
                [self.lock unlockWithCondition:i+1];// 解锁，并且设置lock.condition = condition
            });
        }];
        [task resume];
        
        NSLog(@"********** %d",i);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
