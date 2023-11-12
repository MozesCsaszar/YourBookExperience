package com.example.yourbookstory.data

import android.content.res.Resources
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData

class DataSource() {
    private val initialReviewList = reviewList()
    private val reviewsLiveData = MutableLiveData(initialReviewList)

    fun addReview(review: Review) {
        val currentList = reviewsLiveData.value
        if (currentList == null) {
            reviewsLiveData.postValue(listOf(review))
        } else {
            val updatedList = currentList.toMutableList()
            updatedList.add(0, review)
            reviewsLiveData.postValue(updatedList)
        }
    }

    fun removeReview(id: Int) {
        val currentList = reviewsLiveData.value
        if(currentList != null) {
            val updatedList = currentList.toMutableList()
            for(i in updatedList.indices) {
                if(updatedList[i].id == id) {
                    updatedList.removeAt(i)
                    reviewsLiveData.postValue(updatedList)
                    println("REMOVED ELEMENT")
                    break
                }
            }
        }
    }

    fun updateReview(id: Int, newReview: Review) {
        val currentList = reviewsLiveData.value
        if(currentList != null) {
            val updatedList = currentList.toMutableList()
            for(i in updatedList.indices) {
                if(updatedList[i].id == id) {
                    updatedList[i] = newReview
                    reviewsLiveData.postValue(updatedList)
                    break
                }
            }
        }
    }

    fun getReview(id: Int): Review? {
        reviewsLiveData.value?.let { reviews -> return reviews.firstOrNull { it.id == id } }
        return null
    }

    fun getReviewList(): LiveData<List<Review>> {
        return reviewsLiveData
    }

    // class object to make sure only one instance of the DataSource object is running at any one time
    companion object {
        private var INSTANCE: DataSource? = null
        fun getDataSource(): DataSource {
            val newInstance = INSTANCE ?: DataSource()
            INSTANCE = newInstance
            return newInstance
        }
    }
}