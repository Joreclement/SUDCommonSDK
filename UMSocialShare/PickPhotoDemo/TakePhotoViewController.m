//
//  TakePhotoViewController.m
//  UMSocialShare
//
//  Created by 李赐岩 on 16/1/14.
//  Copyright © 2016年 李赐岩. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "SGMAlbumViewController.h"



@interface TakePhotoViewController ()<UITableViewDataSource, UITableViewDelegate, SGMAlbumViewControllerDelegate>

@end

@implementation TakePhotoViewController{
    UITableView *mainTable;
    NSMutableArray *selectedPhotoArray;
    ALAssetsLibrary *assetLibrary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    selectedPhotoArray = [[NSMutableArray alloc]init];
    
    //全局变量
    assetLibrary = [[ALAssetsLibrary alloc]init];
    
    mainTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mainTable];
    
}

-(void)btTap{
    SGMAlbumViewController* viewVC = [[SGMAlbumViewController alloc] init];
    viewVC.assetsLibrary =assetLibrary;
    viewVC.limitNum = 9;//不设置即不限制
    [viewVC setDelegate:self];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:viewVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton* bt = [[UIButton alloc]initWithFrame:tableView.tableFooterView.bounds];
    [bt setTitle:@"选择照片" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(btTap) forControlEvents:UIControlEventTouchUpInside];
    return bt;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 80;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return selectedPhotoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identify = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if ([[selectedPhotoArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        ALAsset *asset = [[selectedPhotoArray objectAtIndex:indexPath.row] objectForKey:@"asset"];
        cell.imageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    }
    if ([[selectedPhotoArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]])
    {
        cell.imageView.image = [selectedPhotoArray objectAtIndex:indexPath.row];
    }
    else
    {
        
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SGMAlbumViewControllerDelegate
- (BOOL)sendImageWithAssetsArray:(NSArray *)array
{
    if (array.count>0) {
        [selectedPhotoArray addObjectsFromArray:array];
        [mainTable reloadData];
        return YES;
    }
    return NO;
}

@end