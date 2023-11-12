package com.example.yourbookstory.data

import java.io.Serializable

data class Review(
    val id: Int,
    val userId: Int,
    var bTitle: String,
    var bAuthor: String,
    var description: String,
    var experiences: String,
    var pros: List<String>,
    var cons: List<String>,
    var rating: Float
) : Serializable