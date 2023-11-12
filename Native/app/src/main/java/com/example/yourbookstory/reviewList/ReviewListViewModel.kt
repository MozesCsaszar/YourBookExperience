package com.example.yourbookstory.reviewList

import android.content.ClipDescription
import android.content.Context
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.yourbookstory.data.DataSource
import com.example.yourbookstory.data.Review
import java.lang.IllegalArgumentException

class ReviewListViewModel(val dataSource: DataSource): ViewModel() {
    val reviewLiveData = dataSource.getReviewList()

    fun addReview(bTitle: String?, bAuthor: String?, description: String?, experiences: String?, pros: List<String>?, cons: List<String>?, rating: Float?) {
        if(rating != null && bTitle != null && bAuthor!= null) {
            var id: Int = reviewLiveData.value?.size ?: 0;
            dataSource.addReview(Review(id, 1, bTitle ?: "", bAuthor ?: "",
                description ?: "", experiences ?: "", pros ?: listOf(),
                cons ?: listOf(), rating))
        }
    }

    fun updateReview(id: Int, newReview: Review) {
        dataSource.updateReview(id, newReview)
    }

    fun removeReview(id: Int) {
        dataSource.removeReview(id)
    }

}

class ReviewListViewModelFactory(): ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        // check if ReviewListViewModel is of type ViewModel
        if (modelClass.isAssignableFrom(ReviewListViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return  ReviewListViewModel(
                dataSource = DataSource.getDataSource()
            ) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}