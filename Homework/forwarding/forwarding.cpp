#include "checksum.h"
#include "myendian.h"

/**
 * @brief 进行转发时所需的 IP 头的更新：
 *        你需要先检查 IP 头校验和的正确性，如果不正确，直接返回 false ；
 *        如果正确，请更新 TTL 和 IP 头校验和，并返回 true 。
 *        你可以从 checksum 题中复制代码到这里使用。
 * @param packet 收到的 IP 包，既是输入也是输出，原地更改
 * @param len 即 packet 的长度，单位为字节
 * @return 校验和无误且TTL非0则返回 true ，否则返回 false
 */
bool forward(uint8_t *packet, size_t len) {
  // TODO:
  if (!validateIPChecksum(packet, len))
    return false;
  
  // DONE(optional): check ttl=0 case
  if (packet[8] <= 1)
    return false;
  --packet[8];

  fill_ip_checksum(packet);

  return true;
}
