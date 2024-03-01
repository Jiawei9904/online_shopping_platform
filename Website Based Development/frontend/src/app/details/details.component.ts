import { Component, Input, Output, EventEmitter } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FavoriteIconService } from '../services/favorite-icon.service';
import { LoadingService } from '../services/loading.service';

@Component({
  selector: 'app-details',
  templateUrl: './details.component.html',
  styleUrls: ['./details.component.css'],
})
export class DetailsComponent {
  @Input() itemDetails: any; // This property will receive the selected item from the parent
  @Input() itemGeneral: any;
  @Output() backToListEvent = new EventEmitter<void>(); // Event to inform the parent component to show the list again
  inWishList: boolean = false;
  activeSection: string = 'product'; // Default section to show is 'product'
  constructor(
    private http: HttpClient,
    private favoriteIconService: FavoriteIconService,
    private loadingService: LoadingService
  ) {}

  ngOnInit(): void {
    // Any initialization logic for the component can go here
    // For example, you might want to check that itemDetails is not null
    console.log('Complete itemDetails:', this.itemDetails);
    console.log('title:...');
    console.log(this.itemDetails.Item.Title);
    console.log('check general info...');
    console.log(this.itemGeneral);
    this.favoriteIconService.isActive$.subscribe((isActive) => {
      console.log('State in DetailsComponent:', isActive);
      this.inWishList = isActive;
    });
    // 检查当前项目是否在愿望清单中
    console.log(this.itemGeneral.itemId[0]);
    this.checkIfItemInWishlist(this.itemGeneral.itemId[0]);
  }

  // Handle the click event of the Back button
  backToList(): void {
    this.loadingService.setLoading(true);
    this.backToListEvent.emit(); // Inform the parent component to switch the view back to the list
    this.loadingService.setLoading(false);
  }

  // Method to change the active section in the details view
  setActiveSection(section: string): void {
    this.activeSection = section; // Change the current active section
  }

  // for function of adding and removing in mongoDB
  onAddOrRemoveFromCart() {
    console.log('Before:', this.inWishList);
    this.inWishList = !this.inWishList;
    console.log('After:', this.inWishList);
    // this.inWishList = !this.inWishList; // 切换按钮的状态
    this.favoriteIconService.setActiveState(this.inWishList); // share the status of the wishlist button
    if (this.inWishList) {
      // 如果按钮现在是活跃状态，添加商品
      this.http
        .post(
          'https://hw3ebayadvanced.wl.r.appspot.com/api/addToCart',
          this.itemGeneral
        )
        .subscribe(
          (response) => console.log(response),
          (error) => console.error(error)
        );
    } else {
      // 如果按钮不是活跃状态，从数据库中删除商品
      const itemId = this.itemGeneral.itemId[0]; // 假设 itemId 是存储在数组中的字符串
      console.log('need to delete...', itemId);
      this.http
        .post('https://hw3ebayadvanced.wl.r.appspot.com/api/removeFromCart', {
          itemId,
        })
        .subscribe(
          (response) => console.log(response),
          (error) => console.error(error)
        );
    }
  }

  // share on facebook
  shareOnFacebook() {
    if (!this.itemDetails || !this.itemDetails.Item) {
      console.error('Item details are not available');
      return;
    }

    const productName = this.itemDetails.Item.Title;
    const price = this.itemDetails.Item.CurrentPrice?.Value;
    const link = this.itemDetails.Item.ViewItemURLForNaturalSearch;

    this.http
      .post(
        'https://hw3ebayadvanced.wl.r.appspot.com/api/generateFacebookShareLink',
        {
          productName,
          price,
          link,
        }
      )
      .subscribe(
        (response: any) => {
          if (response && response.shareUrl) {
            window.open(response.shareUrl, '_blank');
          }
        },
        (error) => {
          console.error('Failed to generate Facebook share link', error);
        }
      );
  }

  // 新方法：检查当前项目是否在愿望清单中
  checkIfItemInWishlist(itemId: string): void {
    this.http
      .get<string[]>('https://hw3ebayadvanced.wl.r.appspot.com/api/getItemIds')
      .subscribe(
        (idsInDatabase) => {
          console.log('current id...', itemId);
          const flattenedIds = idsInDatabase.flat();
          console.log('get all ids in details...', flattenedIds);
          if (flattenedIds) {
            this.inWishList = flattenedIds.includes(itemId);
          }
        },
        (error) => {
          console.error('Error checking item in wishlist:', error);
        }
      );
  }
}
