//
//  PDFileBrowseController.m
//  PDSandbox
//
//  Created by liang on 2018/3/29.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDFileBrowseController.h"
#import "PDFileBrowser.h"
#import "PDFileBrowser+Internal.h"

static NSString *const kSandboxCellId = @"kSandboxCellId";

typedef NS_ENUM(NSUInteger, PDFileItemType) {
    PDFileItemTypeBack = 0,
    PDFileItemTypeDirectory,
    PDFileItemTypeFile,
};

@interface PDFileItem : NSObject

@property (nonatomic, assign) PDFileItemType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;

@end

@implementation PDFileItem

@end

@interface PDFileBrowseController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<PDFileItem *> *items;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PDFileBrowseController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Browse Page";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createViewHierarchy];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didClickBackButtomItem:)];
    
    self.rootPath = NSHomeDirectory();
    [self loadItemsForPath:self.rootPath];
}

- (void)createViewHierarchy {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.activityIndicatorView];
}

- (void)didClickBackButtomItem:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadItemsForPath:(NSString *)path {
    [self.activityIndicatorView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.items = [self itemsAtPath:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activityIndicatorView stopAnimating];
        });
    });
}

#pragma mark - UITableView Delegate && DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSandboxCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSandboxCellId];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didReciveLongPressGesture:)];
        longPress.minimumPressDuration = 1.f;
        [cell addGestureRecognizer:longPress];
    }
    
    if (indexPath.row <= self.items.count - 1) {
        PDFileItem *item = self.items[indexPath.row];
        UITableViewCellAccessoryType accessoryType = (item.type == PDFileItemTypeFile ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator);
        
        cell.textLabel.text = item.name;
        cell.accessoryType = accessoryType;
    } else {
        cell.textLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row > self.items.count - 1) return;
    
    PDFileItem *item = [self.items objectAtIndex:indexPath.row];
    
    if (item.type == PDFileItemTypeBack) {
        [self loadItemsForPath:[item.path stringByDeletingLastPathComponent]];
    }
    else if (item.type == PDFileItemTypeDirectory) {
        [self loadItemsForPath:item.path];
    }
    else if (item.type == PDFileItemTypeFile) {
        PDFileBrowser *fileBrowser = [PDFileBrowser defaultBrowser];
        UIViewController<PDFilePreviewControllerDelegate> *controller = fileBrowser.filePreviewControllerBlock(item.path);
        [self.navigationController pushViewController:controller animated:YES];
        
        [controller loadFileAtPath:item.path];
    }
}

#pragma mark - Gesture Methods
- (void)didReciveLongPressGesture:(UILongPressGestureRecognizer *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (!indexPath) return;
    if (indexPath.row > self.items.count - 1) return;
    
    PDFileItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.type == PDFileItemTypeBack) return;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = item.path;
    
    cell.detailTextLabel.text = @"已经复制路径到粘贴板";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.detailTextLabel.text = @"";
    });
}

#pragma mark - Tool Methods
- (NSArray<PDFileItem *> *)itemsAtPath:(NSString *)path {
    NSMutableArray<PDFileItem *> *items = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([path isEqualToString:self.rootPath] || path.length == 0) {
        path = self.rootPath;
    } else {
        PDFileItem *item = [[PDFileItem alloc] init];
        item.name = @"🔙..";
        item.type = PDFileItemTypeBack;
        item.path = path;
        [items addObject:item];
    }
    
    NSError *error;
    NSArray<NSString *> *paths = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    for (NSString *tmpPath in paths) {
        if (self.filterHiddenFiles &&
            [[tmpPath lastPathComponent] hasPrefix:@"."]) { // Filter hidden files.
            continue;
        }
        
        BOOL isDirectory = NO;
        NSString *fullPath = [path stringByAppendingPathComponent:tmpPath];
        [fileManager fileExistsAtPath:fullPath isDirectory:&isDirectory];
        
        PDFileItem *item = [[PDFileItem alloc] init];
        item.path = fullPath;
        item.type = isDirectory ? PDFileItemTypeDirectory : PDFileItemTypeFile;
        item.name = [NSString stringWithFormat:@"%@ %@", (isDirectory ? @"📁" : @"📃"), tmpPath];
        
        [items addObject:item];
    }
    
    return [items copy];
}

#pragma mark - Getter Methods
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        CGSize size = CGSizeMake(100.f, 100.f);
        CGRect rect = CGRectMake((CGRectGetWidth(self.view.bounds) - size.width) / 2.f,
                                 (CGRectGetHeight(self.view.bounds) - size.height) / 2.f,
                                 size.width,
                                 size.height);
        _activityIndicatorView.frame = rect;
    }
    return _activityIndicatorView;
}

@end
