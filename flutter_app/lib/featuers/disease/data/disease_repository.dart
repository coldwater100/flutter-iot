import '../domain/disease_entity.dart';

class DiseaseRepositoryImpl {
  // TODO: 이후 API나 DB 연동 가능
  List<DiseaseEntity> fetchDiseaseRecords() {
    return [
      DiseaseEntity(
        id: "1",
        date: "2025-07-15",
        title: "흰가루병 의심",
        description: "잎 표면에 흰색 가루가 생김. 곰팡이 초기 감염 가능성.",
        imagePath: "assets/images/plant_disease1.png",
      ),
      DiseaseEntity(
        id: "2",
        date: "2025-08-01",
        title: "잎마름병 의심",
        description: "잎 끝이 갈색으로 변하면서 말라감. 세균성 감염 가능성.",
        imagePath: "assets/images/plant_disease2.png",
      ),
    ];
  }
}
