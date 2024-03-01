// wishlist.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class WishlistService {
  constructor(private http: HttpClient) {}

  // get wish list
  getWishlist(): Observable<any> {
    return this.http.get(
      'https://hw3ebayadvanced.wl.r.appspot.com/api/wishlist'
    );
  }

  // remove from wishlist
  removeFromWishlist(itemId: string) {
    return this.http.post(
      `https://hw3ebayadvanced.wl.r.appspot.com/api/removeFromCart`,
      {
        itemId: itemId,
      }
    );
  }
}
