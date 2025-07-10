    // 대분류에 따른 소분류 매핑
    const subCategories = {
        "소설": ["한국소설", "외국소설", "역사소설"],
        "과학": ["물리학", "화학", "생물학"],
        "인문": ["철학", "심리학", "종교"],
        "기술": ["컴퓨터", "전자", "기계"],
        "기타": ["에세이", "여행", "요리"]
    };

    function updateSubCategories() {
        const mainSelect = document.getElementById("mainCategory");
        const subSelect = document.getElementById("subCategory");
        const selectedMain = mainSelect.value;

        // 소분류 초기화
        subSelect.innerHTML = "";

        if (selectedMain && subCategories[selectedMain]) {
            subCategories[selectedMain].forEach(function(sub) {
                const option = document.createElement("option");
                option.value = sub;
                option.text = sub;
                subSelect.appendChild(option);
            });
        } else {
            const option = document.createElement("option");
            option.value = "";
            option.text = "소분류 없음";
            subSelect.appendChild(option);
        }
    }