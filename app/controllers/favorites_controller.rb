class FavoritesController < ApplicationController
    def create
        book = Book.find(params[:book_id])
        favorite = current_user.favorites.new(book_id: book.id)
        favorite.save
        #redirect_to request.referer #元の画面に戻る #非同期通信のため削除
    end
    
    def destroy
        book = Book.find(params[:book_id])
        favorite = current_user.favorites.find_by(book_id: book.id)
        favorite.destroy
        #redirect_to request.referer　#非同期通信のため削除
    end

end
