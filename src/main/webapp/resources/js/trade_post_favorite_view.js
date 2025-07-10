// 페이지 로드 시 실행
document.addEventListener("DOMContentLoaded", () => {
  // 모달 닫기 버튼 이벤트 리스너
  const modalButton = document.getElementById("modalButton")
  if (modalButton) {
    modalButton.addEventListener("click", closeModal)
  }

  // 검색 폼 제출 이벤트 리스너
  const searchForm = document.getElementById("searchForm")
  if (searchForm) {
    const searchButton = searchForm.querySelector('button[type="submit"]')
    if (searchButton) {
      searchButton.addEventListener("click", (e) => {
        e.preventDefault()
        searchForm.querySelector('input[name="pageNum"]').value = "1"
        searchForm.submit()
      })
    }
  }

  // 대분류 변경 이벤트 리스너
  const bookMajorCategory = document.getElementById("bookMajorCategory")
  if (bookMajorCategory) {
    bookMajorCategory.addEventListener("change", updateSubCategories)
    // 페이지 로드 시 초기 설정
    updateSubCategories()
  }
})

// 모달 표시 함수
function showModal(type, title, message) {
  const modal = document.getElementById("alertModal")
  const icon = document.getElementById("modalIcon")
  const iconElement = icon.querySelector("i")

  document.getElementById("modalTitle").textContent = title
  document.getElementById("modalMessage").textContent = message

  if (type === "success") {
    icon.className = "modal-icon success"
    iconElement.className = "fas fa-check-circle"
  } else {
    icon.className = "modal-icon error"
    iconElement.className = "fas fa-exclamation-circle"
  }

  modal.classList.add("show")
}

// 모달 닫기 함수
function closeModal() {
  const modal = document.getElementById("alertModal")
  modal.classList.remove("show")
}

// 필터 변경 함수
function changeFilter(status) {
  const actionForm = document.getElementById("actionForm")
  actionForm.querySelector('input[name="status"]').value = status
  actionForm.querySelector('input[name="pageNum"]').value = "1"
  actionForm.submit()
}

// 정렬 변경 함수
function changeSort(sort) {
  const actionForm = document.getElementById("actionForm")
  actionForm.querySelector('input[name="sort"]').value = sort
  actionForm.querySelector('input[name="pageNum"]').value = "1"
  actionForm.submit()
}

// 관심목록에서 삭제 함수
function removeFromWishlist(postId) {
  if (confirm("정말로 관심목록에서 삭제하시겠습니까?")) {
    fetch("/remove_wishlist", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        postId: postId,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          showModal("success", "삭제 완료", data.message)
          // 1.5초 후 페이지 새로고침
          setTimeout(() => {
            location.reload()
          }, 1500)
        } else {
          showModal("error", "삭제 실패", data.message)
        }
      })
      .catch((error) => {
        showModal("error", "오류 발생", "서버 통신 중 오류가 발생했습니다.")
        console.error("Error:", error)
      })
  }
}

// 대분류에 따른 소분류 업데이트 함수
function updateSubCategories() {
  const bookMajorCategory = document.getElementById("bookMajorCategory").value
  const bookSubCategorySelect = document.getElementById("bookSubCategory")

  // 기존 옵션 제거
  bookSubCategorySelect.innerHTML = '<option value="">전체</option>'

  // 대분류에 따른 소분류 옵션 추가
  if (bookMajorCategory === "000-총류") {
    addSubCategories([
      "010-도서관, 서지학",
      "020-문헌정보학",
      "030-백과사전",
      "040-강연, 수필, 연설문집",
      "050-일반학회, 단체, 박물관",
      "060-일반전집",
      "070-신문, 언론, 저널리즘",
      "080-일반전집, 총서",
      "090-향토자료",
    ])
  } else if (bookMajorCategory === "100-철학") {
    addSubCategories([
      "110-형이상학",
      "120-인식론, 인과론, 인간학",
      "130-세계",
      "140-경학",
      "150-동양철학, 사상",
      "160-서양철학",
      "170-논리학",
      "180-윤리학",
      "190-윤리, 도덕교육",
    ])
  } else if (bookMajorCategory === "200-종교") {
    addSubCategories([
      "210-비교종교",
      "220-불교",
      "230-기독교",
      "240-도교",
      "250-천도교",
      "260-신도",
      "270-힌두교, 브라만교",
      "280-회교(이슬람교)",
      "290-기타 제종교",
    ])
  } else if (bookMajorCategory === "300-사회학") {
    addSubCategories([
      "310-통계학",
      "320-경제학",
      "330-사회학, 사회문제",
      "340-정치학",
      "350-행정학",
      "360-법학",
      "370-교육학",
      "380-풍속, 민속학",
      "390-국방, 군사학",
    ])
  } else if (bookMajorCategory === "400-자연과학") {
    addSubCategories([
      "410-수학",
      "420-물리학",
      "430-화학",
      "440-천문학",
      "450-지학",
      "460-생명과학",
      "470-식물학",
      "480-동물학",
      "490-기타 자연과학",
    ])
  } else if (bookMajorCategory === "500-기술과학") {
    addSubCategories([
      "510-의학",
      "520-일반공학, 공학일반",
      "530-기계공학",
      "540-전기, 전자공학",
      "550-건축공학",
      "560-화학공학",
      "570-제조업",
      "580-생활과학",
      "590-기타 기술과학",
    ])
  } else if (bookMajorCategory === "600-예술") {
    addSubCategories([
      "610-건축",
      "620-조각, 조형예술",
      "630-회화",
      "640-서예",
      "650-사진, 인쇄",
      "660-음악",
      "670-공연예술, 매체예술",
      "680-오락, 스포츠",
      "690-기타 예술",
    ])
  } else if (bookMajorCategory === "700-언어") {
    addSubCategories([
      "710-한국어",
      "720-중국어",
      "730-일본어",
      "740-영어",
      "750-독일어",
      "760-프랑스어",
      "770-스페인어",
      "780-기타 언어",
    ])
  } else if (bookMajorCategory === "800-문학") {
    addSubCategories([
      "810-한국문학",
      "820-중국문학",
      "830-일본문학",
      "840-영어문학",
      "850-독일문학",
      "860-프랑스문학",
      "870-스페인문학",
      "880-기타 문학",
    ])
  } else if (bookMajorCategory === "900-역사") {
    addSubCategories([
      "910-한국사",
      "920-동양사",
      "930-서양사",
      "940-역사이론",
      "950-지리학",
      "960-지도, 여행",
      "970-문화사",
      "980-민속사",
      "990-기타 역사",
    ])
  }

  // URL에서 선택된 소분류가 있으면 선택 상태로 만들기
  const urlParams = new URLSearchParams(window.location.search)
  const selectedSubCategory = urlParams.get("bookSubCategory")
  if (selectedSubCategory) {
    bookSubCategorySelect.value = selectedSubCategory
  }
}

// 소분류 옵션 추가 함수
function addSubCategories(categories) {
  const bookSubCategorySelect = document.getElementById("bookSubCategory")
  categories.forEach((category) => {
    const option = document.createElement("option")
    option.value = category
    option.textContent = category
    bookSubCategorySelect.appendChild(option)
  })
}
