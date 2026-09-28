# Handwritten Text Recognition

## About the Project

This project focuses on recognizing handwritten text from images and converting it into digital text.

The project was developed as a solution to the difficulty of converting handwritten documents into editable digital form. This became particularly relevant during the COVID-19 period, when many documents and records were available only in handwritten form.

## Approach

Different deep learning approaches were considered for handwritten text recognition. After evaluating the requirements of the problem, a **CNN-Bi-LSTM** based approach was selected.

The CNN is used to extract useful features from the input handwriting image, while the Bi-LSTM helps understand the sequence of characters in the handwriting.

The model was trained and evaluated using the **IAM Handwriting Database**.

## My Contribution

I worked on the model selection, dataset preparation and development of the Bi-LSTM part of the system.

The initial approaches considered included TrOCR, vision-language models, CRNN with Bi-GRU, and CNN-Bi-LSTM. The CNN-Bi-LSTM approach was selected because it was suitable for recognizing irregular and unaligned handwriting.

My main contributions were:

* Preparing and processing the handwriting dataset
* Working on the Bi-LSTM component of the model
* Supporting the integration of the CNN and Bi-LSTM components
* Evaluating the recognition results
* Analysing the model performance and making improvements where required

## Dataset

The project uses the **IAM Handwriting Database**, which contains handwritten text samples from different writers.

The dataset was preprocessed before being provided to the recognition model.

## Model

The main architecture used in this project is:

**Input Handwriting Image → CNN → Bi-LSTM → Text Output**

The CNN extracts visual features from the handwriting, and the Bi-LSTM processes these features as a sequence to recognize the text.

## Results

The developed system achieved approximately **92% recognition accuracy** during external evaluation.

The project was also selected among the **Top 10 projects** in the relevant evaluation and received an **A+ grade (90 marks)**.

## Technologies Used

* Python
* TensorFlow
* Convolutional Neural Networks (CNN)
* Bidirectional LSTM (Bi-LSTM)
* IAM Handwriting Database
* Image preprocessing
* Deep Learning

## What I Learned

This project gave me practical experience in working with deep learning models, dataset preparation and sequence-based recognition.

It also helped me understand how different model architectures can be evaluated for a problem and how the choice of architecture affects the final result.

## Project Structure

```text
Handwritten-Text-Recognition/
│
├── Dataset/
├── Preprocessing/
├── Model/
├── Evaluation/
├── Results/
└── README.md
```

## Note

This project was developed as an academic project and represents my work and contribution as part of the project team.
