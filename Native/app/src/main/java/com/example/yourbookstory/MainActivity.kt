package com.example.yourbookstory

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.recyclerview.widget.RecyclerView
import com.example.yourbookstory.data.Review
import com.example.yourbookstory.reviewList.ReviewAdapter
import com.example.yourbookstory.reviewList.ReviewListViewModel
import com.example.yourbookstory.reviewList.ReviewListViewModelFactory
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.yourbookstory.editReview.EditReviewActivity

class MainActivity : AppCompatActivity() {
    private val reviewListViewModel by viewModels<ReviewListViewModel> {
        ReviewListViewModelFactory()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val reviewAdapter = ReviewAdapter {review -> adapterOnClick(review)}
        val layoutManager = LinearLayoutManager(this)
        val recyclerView: RecyclerView = findViewById(R.id.review_recycler_view)

        recyclerView.adapter = reviewAdapter
        recyclerView.layoutManager = layoutManager

        findViewById<TextView>(R.id.add).setOnClickListener {
            onAddClick()
        }

        reviewListViewModel.reviewLiveData.observe(this) {
            it?.let {
                reviewAdapter.submitList(it as MutableList<Review>)
            }
        }
    }

    private val editLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
        if (it.resultCode == Activity.RESULT_OK) {
            val data: Intent? = it.data
            if(data != null) {
                println("STEP 1")
                if(data.getBooleanExtra("DELETED", false)) {
                    val reviewId = data.getIntExtra("REVIEW_ID", -1)
                    println("STEP 2")
                    if(reviewId != -1) {
                        println("STEP 3")
                        reviewListViewModel.removeReview(reviewId)
                    }
                }
                else {
                    val review = data.getSerializableExtra("REVIEW") as Review

                    reviewListViewModel.updateReview(review.id, review)
                }
            }
        }
    }
    private val addLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
        if (it.resultCode == Activity.RESULT_OK) {
            val data: Intent? = it.data
            if(data != null) {
                val review = data.getSerializableExtra("REVIEW") as Review

                reviewListViewModel.addReview(review.bTitle, review.bAuthor, review.description,
                    review.experiences, review.pros, review.cons, review.rating)
            }
        }
    }

    private fun adapterOnClick(review: Review) {
        val intent = Intent(this, EditReviewActivity::class.java)
        intent.putExtra("REVIEW", review)
        editLauncher.launch(intent)
    }

    private fun onAddClick() {
        val intent = Intent(this, EditReviewActivity::class.java)
        intent.putExtra("REVIEW", Review(1,1,"","","","", listOf(), listOf(), 0f))
        intent.putExtra("ADD", true)
        addLauncher.launch(intent)
    }
}